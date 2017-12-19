//
//  MTMaze.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation


public class MTMaze: NSObject, Codable {
	
	public var mazeSize: MTMazeSize
	public var mazeBlocks: [[MTRobotDirections]]
	
	public var mazeSeed: String?
	
	public var startPoint: MTTilePosition
	public var endPoint: MTTilePosition
	
	public init(with size: MTMazeSize) {
		self.mazeSize = size
		
		let column = [MTRobotDirections](repeating: MTRobotDirection.allDirections, count: self.mazeSize.y)
		self.mazeBlocks = [[MTRobotDirections]](repeating: column, count: self.mazeSize.x)
		
		for x in 0..<self.mazeSize.x {
			for y in 0..<self.mazeSize.y {
				
				var directions: MTRobotDirections = MTRobotDirection.allDirections
				
				if x == 0 {
					if let i = directions.index(of: .left) {
						directions.remove(at: i)
					}
				}
				
				if y == 0 {
					if let i = directions.index(of: .up) {
						directions.remove(at: i)
					}
				}
				
				if x == self.mazeSize.x - 1 {
					if let i = directions.index(of: .right) {
						directions.remove(at: i)
					}
				}
				
				if y == self.mazeSize.y - 1 {
					if let i = directions.index(of: .down) {
						directions.remove(at: i)
					}
				}
				mazeBlocks[x][y] = directions
			}
		}
		
		startPoint = .zero
		endPoint = size.tilePos - (x: 1, y: 1)
		
		super.init()
	}
	
	public func set(tile point: MTTilePosition, to direction: MTRobotDirections) {
		self.mazeBlocks[point.x][point.y] = direction
	}
	
	override open var description: String {
		return "Maze View"
	}
	
	public func directions(at: MTTilePosition) -> MTRobotDirections {
		return  self.mazeBlocks[at.x][at.y];
	}
	
	public func display() {
		let cellWidth = 3
		for j in 0..<self.mazeSize.y {
			// Draw top edge
			var topEdge = ""
			for i in 0..<self.mazeSize.x {
				topEdge += "+"
				topEdge += String(repeating: !self.mazeBlocks[i][j].contains(.up) ? "-" : " ", count: cellWidth)
			}
			topEdge += "+"
			print(topEdge)
			
			// Draw left edge
			var leftEdge = ""
			for i in 0..<self.mazeSize.x {
				leftEdge += !self.mazeBlocks[i][j].contains(.left) ? "|" : " "
				leftEdge += String(repeating: " ", count: cellWidth)
			}
			leftEdge += "|"
			print(leftEdge)
		}
		
		// Draw bottom edge
		var bottomEdge = ""
		for _ in 0..<self.mazeSize.x {
			bottomEdge += "+"
			bottomEdge += String(repeating: "-", count: cellWidth)
		}
		bottomEdge += "+"
		print(bottomEdge)
	}
	
	
}
