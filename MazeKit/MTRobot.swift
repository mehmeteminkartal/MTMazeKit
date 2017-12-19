//
//  MTRobot.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

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
	
	public enum turnDirection {
		case left
		case right
		case back
	}
	
	open var canRotate: Bool {
		return true
	}
	
	open var robotIconName: String {
		return "Original_PacMan"
	}
	
	public var robotPos: MTTilePosition = .init(x: 0, y: 0)
	public var robotDirection: MTRobotDirection = .down
	
	public weak var maze: MTMaze!
	
	open func mazeUpdated(to maze: MTMaze) {
		self.maze = maze
		clearCache();
	}
	
	private func clearCache() {
		let column = [Int](repeating: 0, count: self.maze.mazeSize.y)
		self.mazeCache = [[Int]](repeating: column, count: self.maze.mazeSize.x)
	}
	
	public var status: MTRobotStatus = .stopped
	
	private var mazeCache: [[Int]] = []
	
	
	private func getCachedValue(for path: MTTilePosition) -> Int {
		
		if maze == nil {
			return -1
		}
		
		if self.maze.mazeSize.inBounds(tile: path) {
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
		
		if directions.contains(self.robotDirection.moveLeft()) {
			turn(.left)
			forward()
		} else if directions.contains(self.robotDirection) {
			forward()
		} else if directions.contains(self.robotDirection.moveRight()) {
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
		
		if(self.robotPos == MTTilePosition(x: self.maze.mazeSize.x - 1,y: self.maze.mazeSize.y - 1)) {
			self.status = .finished
			//NotificationCenter.default.post(name: .MTMazeNewMazeNotification, object: nil)
		}
	}
	
	
	public func turn(_ direction: turnDirection) {
		if score < 5 {
			self.status = .exhausted
			return
		}
		
		numberOfTurns += 1
		self.score -= 5
		switch direction {
		case .back:
			self.robotDirection = self.robotDirection.opposite
		case .left:
			self.robotDirection = self.robotDirection.moveLeft()
		case .right:
			self.robotDirection = self.robotDirection.moveRight()
		}
		
		let val = self.getCachedValue(for: self.robotPos)
		self.setCachedValue(for: self.robotPos, to: val + 1)
		
	}
	
	func getDirections() -> MTRobotDirections {
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
			if(self.maze.mazeSize.inBounds(tile: self.robotPos + self.robotDirection.diff)) {
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

