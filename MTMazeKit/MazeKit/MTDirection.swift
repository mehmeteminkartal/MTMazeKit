//
//  MTRobotDirection.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation

public typealias MTDirections = [MTDirection]

public enum MTTurnDirection {
	case left
	case right
	case back
}

extension Array where Element == MTDirection {
	public var directionsAsString: String {
		var l = ""
		for i in MTDirection.allDirections {
			if self.contains(i) {
				l += "\(i.char)"
			}
		}
		return l
	}
}

@objc public enum MTDirection: Int, Codable, CustomStringConvertible {
	public var description: String {
		return "\(self.char)"
	}
	
	case up = 1
	case down = 2
	case right = 4
	case left = 8
	
	
	public func turn(_ turnDirection: MTTurnDirection) -> MTDirection {
		switch turnDirection {
			
		case .left:
			return self.moveLeft()
		case .right:
			return self.moveRight()
		case .back:
			return self.opposite
		}
	}
	
	private func moveLeft() -> MTDirection {
		switch self {
		case .up:
			return .left
		case .down:
			return .right
		case .right:
			return .up
		case .left:
			return .down
		}
	}
	
	private func moveRight() -> MTDirection {
		switch self {
		case .up:
			return .right
		case .down:
			return .left
		case .right:
			return .down
		case .left:
			return .up
		}
	}
	
	public static var allDirections:[MTDirection] {
		return [MTDirection.up, MTDirection.down, MTDirection.right, MTDirection.left]
	}
	
	public var opposite:MTDirection {
		switch self {
		case .up:
			return .down
		case .down:
			return .up
		case .right:
			return .left
		case .left:
			return .right
		}
	}
	
	public var diff:(x: Int, y: Int) {
		switch self {
		case .up:
			return (x: 0, y: -1)
		case .down:
			return (0, 1)
		case .right:
			return (1, 0)
		case .left:
			return (-1, 0)
		}
	}
	
	public var char: Character {
		switch self {
		case .up:
			return "U"
		case .down:
			return "D"
		case .right:
			return "R"
		case .left:
			return "L"
		}
	}
	
}
