//
//  MTMazeGenerator.swift
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
	
	var size: MTMazeSize
	var maze:[[Int]]
	var cellWidth = 24;
	var randomSource: GKARC4RandomSource
	
	var seed: String?
	
	public init(size: MTMazeSize, seed: String) {
		self.size = size
		
		let column = [Int](repeating: 0, count: size.y)
		self.maze = [[Int]](repeating: column, count: size.x)
		
		self.seed = seed
		self.randomSource = GKARC4RandomSource(seed: seed.data(using: .utf8)!)
		
		generateMaze(0, 0)
	}
	
	private func generateMaze(_ cx:Int, _ cy:Int) {
		var directions = MTDirection.allDirections
		
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
	
	public func getMaze() -> MTMaze {
		let maze = MTMaze(with: size);
		for j in 0..<size.y {
			for i in 0..<size.x {
				let position = MTTilePosition(x: i, y: j)
				let direction = directions(at: position)
				maze.set(tile: position, to: direction)
			}
		}
		maze.mazeSeed = self.seed
		
		return maze
	}
	
	func directions(at position: MTTilePosition) -> MTDirections {
		var directions: MTDirections = []
		let value = self.maze[position.x][position.y];
		for direction in MTDirection.allDirections {
			if (value & direction.rawValue) != 0 {
				directions.append(direction)
			}
		}
		return directions;
	}
}
