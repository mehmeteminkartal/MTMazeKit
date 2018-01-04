//
//  MTTilePosition.swift
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

/// Tile Position class for maze
public struct MTTilePosition: Codable, Equatable, CustomStringConvertible {
	public var description: String {
		return "(x: \(x), y: \(y))"
	}
	
	/// Initialise Tile Position
	///
	/// - Parameters:
	///   - x: X Coordinate for given tile with top left coordinate space
	///   - y: Y Coordinate for given tile with top left coordinate space
	public init(x: Int, y: Int) {
		self.x = x
		self.y = y
	}
	
	public static func ==(lhs: MTTilePosition, rhs: MTTilePosition) -> Bool {
		return lhs.x == rhs.x && lhs.y == rhs.y
	}
	
	public static func +(lhs: MTTilePosition, rhs: (x: Int, y: Int)) -> MTTilePosition {
		return MTTilePosition(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	
	public static func +=(lhs: inout MTTilePosition, rhs: (x: Int, y: Int)) {
		lhs = lhs + rhs
	}
	
	public static func -(lhs: MTTilePosition, rhs: (x: Int, y: Int)) -> MTTilePosition {
		return MTTilePosition(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	
	public static func -=(lhs: inout MTTilePosition, rhs: (x: Int, y: Int)) {
		lhs = lhs - rhs
	}
	
	public static var zero: MTTilePosition {
		return MTTilePosition(x: 0, y: 0)
	}
	
	public var x: Int
	public var y: Int
	
	/// Returns the next tile at the direction
	///
	/// - Parameter direction: Direction can be .left, .right or .back
	/// - Returns: Tile Position
	func nextTile(at direction: MTDirection) -> MTTilePosition {
		return self + direction.diff
	}
	
	public var int2: vector_int2 {
		return vector_int2(Int32(x), Int32(y))
	}
}
