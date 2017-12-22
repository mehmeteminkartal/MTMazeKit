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
	
	public override init() {
		super.init()
	}
	
	open var name: String {
		return "Robot1"
	}
	
	
	public var uuid = UUID()
	
	public var numberOfMoves = 0;
	public var numberOfTurns = 0;
	
	public var score = 10000
	
	public var totalScore = 0
	
	public func startRobot() {
		self.status = .running
		self.numberOfMoves = 0
		self.numberOfTurns = 0
		self.score = 10000
	}
	
	open var canRotate: Bool {
		return true
	}
	
	open var robotIconName: String {
		return "Original_PacMan"
	}
	
	public var robotPos: MTTilePosition = .init(x: 0, y: 0)
	public var robotDirection: MTDirection = .down
	
	public weak var maze: MTMaze!
	
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
	
	
	private func getCachedValue(for path: MTTilePosition) -> Int {
		
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
		
		if(self.robotPos == MTTilePosition(x: self.maze.size.x - 1,y: self.maze.size.y - 1)) {
			self.status = .finished
			//NotificationCenter.default.post(name: .MTMazeNewMazeNotification, object: nil)
		}
	}
	
	
	public func turn(_ direction: MTTurnDirection) {
		if score < 5 {
			self.status = .exhausted
			return
		}
		
		numberOfTurns += 1
		self.score -= 5
		
		self.robotDirection = self.robotDirection.turn(direction)
		
		let val = self.getCachedValue(for: self.robotPos)
		self.setCachedValue(for: self.robotPos, to: val + 1)
		
	}
	
	func getDirections() -> MTDirections {
		return self.maze.directions(at: self.robotPos);
	}
	
	public func forward() {
		if score < 10 {
			self.status = .exhausted
			return
		}
		
		self.numberOfMoves += 1
		self.score -= 10
		
		if self.getDirections().contains(self.robotDirection) {
			if(self.maze.size.inBounds(tile: self.robotPos + self.robotDirection.diff)) {
				self.robotPos += self.robotDirection.diff
				
				let val = self.getCachedValue(for: self.robotPos)
				self.setCachedValue(for: self.robotPos, to: val + 1)
				
			} else {
				print("illegal move!");
				self.status = .disqualified
			}
		} else {
			print("illegal move!");
			self.status = .disqualified
		}
	}
	
}

