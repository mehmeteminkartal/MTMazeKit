//
//  MTTilePosition.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//


import Foundation

public struct MTTilePosition: Codable, Equatable, CustomStringConvertible {
	public var description: String {
		return "(x: \(x), y: \(y))"
	}
	
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
	
	func nextTile(at direction: MTDirection) -> MTTilePosition {
		return self + direction.diff
	}
}
