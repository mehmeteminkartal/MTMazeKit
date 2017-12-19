//
//  MTMazeSize.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation


public struct MTMazeSize: Codable {
	
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

