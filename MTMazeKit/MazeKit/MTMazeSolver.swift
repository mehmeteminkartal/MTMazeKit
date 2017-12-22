//
//  MTMazeSolver.swift
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


public class MTMazeSolver: NSObject {
	
	public var maze: MTMaze
	var mazeMap: [[Int]] = []
	
	public init(with maze: MTMaze) {
		self.maze = maze
		
		
		let cols = [Int].init(repeating: 0, count: self.maze.size.y)
		mazeMap = [[Int]].init(repeating: cols, count: self.maze.size.x)
		
	}
	
	var steps: [MTDirection?] = []
	
	public func solve(from: MTTilePosition, to: MTTilePosition) -> MTDirections {
		
		recStart(from, 0, nil)
		
		self.steps = .init(repeating: nil, count: maxSteps);
		
		var pos = to
		
		for i in (0...maxSteps).reversed() {
			let directions = maze.directions(at: pos)
			for dir in directions {
				let newPos = pos + dir.diff;
				if self.maze.size.inBounds(tile: newPos) && self.mazeMap[newPos.x][newPos.y] == (i - 1) {
					self.steps[i - 1] = dir.opposite
					pos += dir.diff
				}
			}
		}
		
		var steps: MTDirections = [];
		for s in self.steps {
			if let a = s {
				steps.append(a)
			}
		}
		return steps
	}
	
	var maxSteps = 0;
	private func recStart(_ pos: MTTilePosition, _ val: Int, _ opposite: MTDirection? ) {
		
		if self.maze.size.inBounds(tile: pos) {
			self.mazeMap[pos.x][pos.y] = val
			
			if pos == self.maze.endPoint {
				maxSteps = val
			}
			
			let directions = maze.directions(at: pos)
			
			for dir in directions {
				if opposite != dir {
					
					let newPos = pos + dir.diff;
					if self.maze.size.inBounds(tile: newPos) && self.mazeMap[newPos.x][newPos.y] == 0 {
						recStart(newPos, val + 1, dir.opposite)
					}
				}
			}
		}
	}
}
