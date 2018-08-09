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
	
	public var steps: [MTDirection] = []
	
	public func solve(from: MTTilePosition, to: MTTilePosition) -> MTDirections {
//		print("Solving from: \(from), to: \(to)")
		
		let cols = [Int].init(repeating: 0, count: self.maze.size.y)
		mazeMap = [[Int]].init(repeating: cols, count: self.maze.size.x)
		
		
		recStart(from, 1, nil, to)

		
		var steps: [MTDirection?] = .init(repeating: nil, count: maxSteps);

		var pos = to
		var i = maxSteps + 1;
		var solved = false;
		
		var ssteps = 0;
		
		var lowest = maxSteps + 1;
		
		while !solved && i > 1 {
			i -= 1;
			let directions = maze.directions(at: pos)
			for dir in directions {
				let newPos = pos + dir.diff;
				if self.maze.size.inBounds(tile: newPos) && self.mazeMap[newPos.x][newPos.y] != 0 {
					lowest = min(self.mazeMap[newPos.x][newPos.y], lowest);
				}
			}

			for dir in directions {
				let newPos = pos + dir.diff;
				if self.maze.size.inBounds(tile: newPos) && self.mazeMap[newPos.x][newPos.y] == lowest {

					steps[i - 1] = dir.opposite
					pos += dir.diff
					
					ssteps += 1;
					if pos == to {
						solved = true
					}
				}
			}
		}

		self.steps = [];
		for s in steps {
			if let a = s {
				self.steps.append(a)
			}
		}
		self.cpos = 0
		return self.steps
	}
	
	var cpos = 0;
	public func getNext(_ f: Bool = true) -> MTDirection? {
		if cpos < self.steps.count {
			if f {
				cpos += 1
				return self.steps[cpos - 1]
			} else {
				return self.steps[cpos]
			}
			
		} else {
			return nil
		}
	}
	
	var maxSteps = 0;
	private func recStart(_ pos: MTTilePosition, _ val: Int, _ opposite: MTDirection?, _ to: MTTilePosition) {
		// loopfill
		
		var curVal = 1;
		self.mazeMap[pos.x][pos.y] = val;


		for _ in 0...Int(pow(Double(self.maze.size.x * self.maze.size.y), 2)) {
			
			var filled = false;
			for i in self.maze.size {
				
				if self.mazeMap[i.x][i.y] == curVal {
					let directions = maze.directions(at: i)
					
					
					for dir in directions {
						let newPos = i + dir.diff;
						if maze.size.inBounds(tile: newPos) && self.mazeMap[newPos.x][newPos.y] == 0 {
							self.mazeMap[newPos.x][newPos.y] = curVal + 1;
							filled = true
						}
					}
					
					
					if i == to {
						maxSteps = curVal
						return
					}
				}
				
			}
			if !filled {
				return
			}
			curVal += 1
		}
	}
}
