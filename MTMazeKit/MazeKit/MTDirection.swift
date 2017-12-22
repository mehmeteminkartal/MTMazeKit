//
//  MTRobotDirection.swift
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
