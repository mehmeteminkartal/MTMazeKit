//
//  MTBlockMaze.swift
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

public enum MTBlockMazeTile {
	case empty
	case obstacle(Int)
	case wall
}

public class MTBlockMaze: NSObject {
	
	public var size: MTMazeSize
	public var mazeBlocks: [[MTBlockMazeTile]]
	
	public var mazeSeed: String?
	
	public var startPoint: MTTilePosition
	public var endPoint: MTTilePosition
	
	public init(with size: MTMazeSize) {
		self.size = size
		
		let column = [MTBlockMazeTile](repeating: .empty, count: self.size.y)
		self.mazeBlocks = [[MTBlockMazeTile]](repeating: column, count: self.size.x)
		
		
		
		startPoint = .zero
		endPoint = size.tilePos - (x: 1, y: 1)
		
		super.init()
	}
	
	public func set(tile point: MTTilePosition, to tile: MTBlockMazeTile) {
		if self.size.inBounds(tile: point) {
			self.mazeBlocks[point.x][point.y] = tile
		}
	}
	
	override open var description: String {
		return "Maze View"
	}
	
	public func directions(at tile: MTTilePosition) -> MTBlockMazeTile {
		if self.size.inBounds(tile: tile) {
			return self.mazeBlocks[tile.x][tile.y];
		} else {
			return .wall
		}
	}
	
	public func display() {
		var o = "";
		for y in 0..<self.size.y {
			for x in 0..<self.size.x {
				let b = self.mazeBlocks[x][y]
				switch b {
				case .empty:
					o += " "
				case .obstacle:
					o += "."
				case .wall:
					o += "#"
				}
			}
			o += "\n"
		}
		print(o)
	}
	
	
}

