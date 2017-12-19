//
//  MTRobotDirection.swift
//  MTMazeKit
//
//  Created by Muhammet Mehmet Emin Kartal on 12/19/17.
//  Copyright © 2017 Mekatrotekno. All rights reserved.
//

import Foundation

public typealias MTRobotDirections = [MTRobotDirection]

extension Array where Element == MTRobotDirection {
	public var directionsAsString: String {
		var l = ""
		for i in MTRobotDirection.allDirections {
			if self.contains(i) {
				l += "\(i.char)"
			}
		}
		return l
	}
}

@objc public enum MTRobotDirection: Int, Codable, CustomStringConvertible {
	public var description: String {
		return "\(self.char)"
	}
	
	case up = 1
	case down = 2
	case right = 4
	case left = 8
	
	public func moveLeft() -> MTRobotDirection {
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
	
	public func moveRight() -> MTRobotDirection {
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
	
	public static var allDirections:[MTRobotDirection] {
		return [MTRobotDirection.up, MTRobotDirection.down, MTRobotDirection.right, MTRobotDirection.left]
	}
	
	public var opposite:MTRobotDirection {
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
