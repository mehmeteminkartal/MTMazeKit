//
//  MTMaze.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation


public class MTMaze: NSObject, Codable {
	
	public var size: MTMazeSize
	public var mazeBlocks: [[MTDirections]]
	
	public var mazeSeed: String?
	
	public var startPoint: MTTilePosition
	public var endPoint: MTTilePosition
	
	public init(with size: MTMazeSize) {
		self.size = size
		
		let column = [MTDirections](repeating: MTDirection.allDirections, count: self.size.y)
		self.mazeBlocks = [[MTDirections]](repeating: column, count: self.size.x)
		
		for x in 0..<self.size.x {
			for y in 0..<self.size.y {
				
				var directions: MTDirections = MTDirection.allDirections
				
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
				
				if x == self.size.x - 1 {
					if let i = directions.index(of: .right) {
						directions.remove(at: i)
					}
				}
				
				if y == self.size.y - 1 {
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
	
	public func set(tile point: MTTilePosition, to direction: MTDirections) {
		self.mazeBlocks[point.x][point.y] = direction
	}
	
	override open var description: String {
		return "Maze View"
	}
	
	public func directions(at: MTTilePosition) -> MTDirections {
		return  self.mazeBlocks[at.x][at.y];
	}
	
	public func display() {
		let cellWidth = 3
		for j in 0..<self.size.y {
			// Draw top edge
			var topEdge = ""
			for i in 0..<self.size.x {
				topEdge += "+"
				topEdge += String(repeating: !self.mazeBlocks[i][j].contains(.up) ? "-" : " ", count: cellWidth)
			}
			topEdge += "+"
			print(topEdge)
			
			// Draw left edge
			var leftEdge = ""
			for i in 0..<self.size.x {
				leftEdge += !self.mazeBlocks[i][j].contains(.left) ? "|" : " "
				leftEdge += String(repeating: " ", count: cellWidth)
			}
			leftEdge += "|"
			print(leftEdge)
		}
		
		// Draw bottom edge
		var bottomEdge = ""
		for _ in 0..<self.size.x {
			bottomEdge += "+"
			bottomEdge += String(repeating: "-", count: cellWidth)
		}
		bottomEdge += "+"
		print(bottomEdge)
	}
	
	
}