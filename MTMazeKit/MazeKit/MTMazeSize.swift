//
//  MTMazeSize.swift
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


public struct MTTilePositionIterator: IteratorProtocol {
	let size: MTMazeSize
	var times = 0
	
	public init(_ size: MTMazeSize) {
		self.size = size
	}
	
	mutating public func next() -> MTTilePosition? {
		let nextNumber =  times
		let tile = MTTilePosition(x: nextNumber % size.x, y: (nextNumber - (nextNumber % size.x)) / size.y)
		guard nextNumber < size.x * size.y
			else { return nil }
		
		times += 1
		return tile
	}
}

public struct MTMazeSize: Codable, Sequence, CustomDebugStringConvertible, CustomStringConvertible {
	public var debugDescription: String {
		return self.tilePos.debugDescription
	}
	
	public var description: String {
		return self.tilePos.description
	}
	
	
	public typealias Iterator = MTTilePositionIterator
	public func makeIterator() -> MTMazeSize.Iterator {
		return MTTilePositionIterator(self)
	}
	
	public init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
	
	public var x: Int
	public var y: Int
	
	public var cgSize: CGSize {
		return CGSize(width: x, height: y)
	}
	
	public var tilePos: MTTilePosition {
		return MTTilePosition(x: x, y: y)
	}
	
	public func inBounds(tile: MTTilePosition) -> Bool {
		return inBounds(x: tile.x, y: tile.y)
	}
	
	public func inBounds(x: Int, y: Int) -> Bool {
		return inBounds(value:x, upper:self.x) && inBounds(value:y, upper:self.y)
	}
	
	private func inBounds(value:Int, upper:Int) -> Bool {
		return (value >= 0) && (value < upper)
	}
}

