//
//  MTMazeGenerator.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation
import GameKit

extension Array {
	mutating func swap(_ index1:Int, _ index2:Int) {
		let temp = self[index1]
		self[index1] = self[index2]
		self[index2] = temp
	}
	
	mutating func shuffle(_ source: GKARC4RandomSource) {
		for _ in 0..<self.count {
			let index1 = abs(source.nextInt()) % self.count
			let index2 = abs(source.nextInt()) % self.count
			self.swap(index1, index2)
		}
	}
}

public class MTMazeGenerator {
	let x:Int
	let y:Int
	var maze:[[Int]]
	var cellWidth = 24;
	var randomSource: GKARC4RandomSource
	
	var seed: String?
	
	public init(_ x:Int, _ y:Int, seed: String) {
		self.x  = x
		self.y = y
		let column = [Int](repeating: 0, count: y)
		self.maze = [[Int]](repeating: column, count: x)
		
		self.seed = seed
		self.randomSource = GKARC4RandomSource(seed: seed.data(using: .utf8)!)
		
		generateMaze(0, 0)
	}
	
	private func generateMaze(_ cx:Int, _ cy:Int) {
		var directions = MTRobotDirection.allDirections
		
		directions.shuffle(self.randomSource)
		
		for direction in directions {
			let (dx, dy) = direction.diff
			let nx = cx + dx
			let ny = cy + dy
			if size.inBounds(x: nx, y: ny) && maze[nx][ny] == 0 {
				maze[cx][cy] |= direction.rawValue
				maze[nx][ny] |= direction.opposite.rawValue
				generateMaze(nx, ny)
			}
		}
	}
	
	var size: MTMazeSize {
		return MTMazeSize(x: self.x, y: self.y)
	}
	
	public func getMaze() -> MTMaze {
		let maze = MTMaze(with: size);
		for j in 0..<y {
			for i in 0..<x {
				let position = MTTilePosition(x: i, y: j)
				let direction = directions(at: position)
				maze.set(tile: position, to: direction)
			}
		}
		maze.mazeSeed = self.seed
		
		return maze
	}
	
	func directions(at position: MTTilePosition) -> MTRobotDirections {
		var directions: MTRobotDirections = []
		let value = self.maze[position.x][position.y];
		for direction in MTRobotDirection.allDirections {
			if (value & direction.rawValue) != 0 {
				directions.append(direction)
			}
		}
		return directions;
	}
}
