//
//  MTMazeSolver.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

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
