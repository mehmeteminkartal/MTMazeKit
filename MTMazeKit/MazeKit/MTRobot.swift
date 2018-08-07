//
//  MTRobot.swift
//  MTMazeKit
//
//  MIT License
//
//  Copyright (c) 2017 Muhammet Mehmet Emin KARTAL

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import Foundation

public extension Notification.Name {
	static var MTMazeNewMazeNotification: NSNotification.Name {
		return NSNotification.Name("com.mekatrotekno.mazesolver.newmaze")
	}
}

@objc public enum MTRobotStatus: Int, CustomStringConvertible {
	case stopped = 0
	case running = 1
	case finished = 2
	case disqualified = 3
	case exhausted = 4
	
	public var description: String {
		switch self {
			
		case .stopped:
			return "Stopped"
		case .running:
			return "Running"
		case .finished:
			return "Finished"
		case .disqualified:
			return "Disqualified"
		case .exhausted:
			return "Exhausted"
		}
	}
}

open class MTRobot: NSObject {
	
	public var plan: MTDirections?
	public var planPos: MTTilePosition?
	
	public override init() {
		super.init()
	}
	
	open var name: String {
		return "Robot1"
	}
	
	
	public var uuid = UUID()
	
	public var numberOfMoves = 0;
	public var numberOfTurns = 0;
	
	public var score = 10000000000
	
	public var totalScore = 0
	
	public func startRobot() {
		self.status = .running
		self.numberOfMoves = 0
		self.numberOfTurns = 0
		self.score = 10000000000
	}
	
	open var canRotate: Bool {
		return true
	}
	
	open var robotIconName: String {
		return "Original_PacMan"
	}
	
	public var robotPos: MTTilePosition = .init(x: 0, y: 0)
	public var robotDirection: MTDirection = .down
	
	fileprivate weak var maze: MTMaze!
	
	open func mazeUpdated(to maze: MTMaze) {
		self.maze = maze
		clearCache();
	}
	
	private func clearCache() {
		let column = [Int](repeating: 0, count: self.maze.size.y)
		self.mazeCache = [[Int]](repeating: column, count: self.maze.size.x)
	}
	
	public var status: MTRobotStatus = .stopped
	
	private var mazeCache: [[Int]] = []
	
	
	public func getCachedValue(for path: MTTilePosition) -> Int {
		
		if maze == nil {
			return -1
		}
		
		if self.maze.size.inBounds(tile: path) {
			return mazeCache[path.x][path.y]
		} else {
			return -1
		}
	}
	
	private func setCachedValue(for path: MTTilePosition, to value: Int) {
		mazeCache[path.x][path.y] = value
	}
	
	open func runAlgo() {
		
		let directions = self.getDirections()
		
		if directions.contains(self.robotDirection.turn(.left)) {
			turn(.left)
			forward()
		} else if directions.contains(self.robotDirection) {
			forward()
		} else if directions.contains(self.robotDirection.turn(.right)) {
			turn(.right)
			forward()
		} else  {
			turn(.back)
			forward()
		}
		
	}
	
	public func robotTick() {
		
		
		// _ = self.tick?.call(withArguments: [])
		
		runAlgo();
		
		/*if(self.robotPos == maze.endPoint) {
			self.status = .finished
			
			NotificationCenter.default.post(name: .MTMazeNewMazeNotification, object: nil)
		}*/
	}
	
	
	public func turn(_ direction: MTTurnDirection) {
		if score < 5 {
			self.status = .exhausted
			return
		}
		
		numberOfTurns += 1
		self.score -= 5
		
//		print("Turn \(direction)")
		
		self.robotDirection = self.robotDirection.turn(direction)
		
		let val = self.getCachedValue(for: self.robotPos)
		self.setCachedValue(for: self.robotPos, to: val + 1)
		
	}
	
	fileprivate func getDirections() -> MTDirections {
		return self.maze.directions(at: self.robotPos);
	}
	
	public var frontSensor: Int? {
		var s = 0;
		var position: MTTilePosition = self.robotPos
		while self.maze.directions(at: position).contains(self.robotDirection) {
			position = position.nextTile(at: self.robotDirection)
			s += 1;
			if s > 4 {
				return nil
			}
		}
		return s
	}
	
	
	public var leftSensor: Int? {
		var s = 0;
		let dir = robotDirection.turn(.left)
		var position: MTTilePosition = self.robotPos
		while self.maze.directions(at: position).contains(dir) {
			position = position.nextTile(at: dir)
			s += 1;
			if s > 4 {
				return nil
			}
		}
		return s
	}
	
	public var rightSensor: Int? {
		var s = 0;
		let dir = robotDirection.turn(.right)
		var position: MTTilePosition = self.robotPos
		while self.maze.directions(at: position).contains(dir) {
			position = position.nextTile(at: dir)
			s += 1;
			if s > 4 {
				return nil
			}
		}
		return s
	}
	
	var canGoForward: Bool {
		if self.getDirections().contains(self.robotDirection) {
			let np = self.robotPos.nextTile(at: self.robotDirection)
			
			if self.maze.size.inBounds(tile: np) {
				return true
			} else {
				return false
			}
		} else {
			return false;
		}
	}
	
	var canGoBackward: Bool {
		if self.getDirections().contains(self.robotDirection.opposite) {
			let np = self.robotPos.nextTile(at: self.robotDirection.opposite)
			
			if self.maze.size.inBounds(tile: np) {
				return true
			} else {
				return false
			}
		} else {
			return false;
		}
	}
	
	public func forward() {
		if score < 10 {
			self.status = .exhausted
			return
		}
		
		self.numberOfMoves += 1
		self.score -= 10
		
		if self.canGoForward {
			self.robotPos += self.robotDirection.diff
			
			let val = self.getCachedValue(for: self.robotPos)
			self.setCachedValue(for: self.robotPos, to: val + 1)
//			print("Move Forward")
		} else {
			print("illegal move! Robot tried to go forwards");
			self.status = .disqualified
		}
	}
	
	public var isFinished: Bool {
		return self.robotPos == self.maze.endPoint
	}
	
	public func backward() {
		if score < 10 {
			self.status = .exhausted
			return
		}
		
		self.numberOfMoves += 1
		self.score -= 10
		
		if self.canGoBackward {
			self.robotPos += self.robotDirection.opposite.diff
			
			let val = self.getCachedValue(for: self.robotPos)
			self.setCachedValue(for: self.robotPos, to: val + 1)
//			print("Move backwards")
		} else {
			print("illegal move! Robot tried to go backwards");
			self.status = .disqualified
		}
	}
	
}

