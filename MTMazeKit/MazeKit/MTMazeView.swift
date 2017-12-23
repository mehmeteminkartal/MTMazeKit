//
//  MTMazeView.swift
//  MTMazeKi
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

import UIKit

public protocol MTMazeViewDelegate {
	
	/// Called when maze stats are updated
	///
	/// - Parameters:
	///   - mazeView: Maze Object
	///   - didUpdateStats: Stat text multiline
	func mazeView(_ mazeView: MTMazeView, didUpdateStats string: String)
}


open class MTRobotView: UIImageView {
	public var robot: MTRobot
	
	public init(robot: MTRobot) {
		self.robot = robot
		super.init(image: UIImage(named: self.robot.robotIconName))
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

open class MTMazeView: UIView {
	
	
	public var delegate: MTMazeViewDelegate?
	
	public var isRunning = false;
	
	public var robots: [MTRobot] = []
	public var robotViews: [MTRobotView] = []
	public var maze: MTMaze?
	public var isDummy = false
	public var mazeBlocks: [[UIImageView]] = []
	
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		//robotImageView.layer.zPosition = 1000
		//self.addSubview(robotImageView);
	}
	
	public func emptyMaze() {
		let maze = MTMaze(with: MTMazeSize(x: 5, y: 5))
		self.setMaze(to: maze)
	}
	
	public func new(robot: MTRobot) {
		let robotView = MTRobotView(robot: robot)
		
		self.robots.append(robot)
		robotViews.append(robotView)
		if !isDummy {
			if let maze = self.maze {
				robot.mazeUpdated(to: maze)
			}
		}
		self.addSubview(robotView)
		robotView.layer.zPosition = 1000
	}
	
	public func robotTicks() {
		if !isRunning {
			return
		}
		oneTick();
	}
	
	public func oneTick() {
		for robotView in robotViews {
			if robotView.robot.status == .running {
				robotView.robot.robotTick()
				self.update(robotView)
			}
		}
	}
	
	public func updateRobots() {
		for robotView in robotViews {
			self.update(robotView)
		}
	}
	
	public func update(_ robotView: MTRobotView) {
		UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear], animations: {
			robotView.frame = self.getPosition(robotView.robot.robotPos.x, robotView.robot.robotPos.y)
			
			if robotView.robot.canRotate {
				switch robotView.robot.robotDirection {
				case .up:
					robotView.transform = .identity
				case .down:
					robotView.transform = CGAffineTransform(rotationAngle: .pi);
				case .right:
					robotView.transform = CGAffineTransform(rotationAngle: .pi / 2.0);
				case .left:
					robotView.transform = CGAffineTransform(rotationAngle: (3.0 * .pi) / 2.0);
				}
			} else {
				robotView.transform = .identity
			}
		}) { (_) in
			
		}
		
		updateStats()
	}
	
	public func setMaze(to maze: MTMaze) {
		self.maze = maze
		
		
		for m in mazeBlocks {
			for n in m {
				n.removeFromSuperview()
			}
		}
		mazeBlocks.removeAll()
		
		for j in 0..<maze.size.y {
			var rows: [UIImageView] = []
			
			for i in 0..<maze.size.x {
				let d = maze.directions(at: MTTilePosition(x: i, y: j)).directionsAsString
				
				if let image = UIImage(named: d) {
					let imageView = UIImageView(image: image);
					
					self.addSubview(imageView);
					//imageView.frame = getPosition(i, j);
					rows.append(imageView)
				}
			}
			self.mazeBlocks.append(rows)
		}
		if !isDummy {
			for robot in robots {
				robot.robotPos = maze.startPoint
				robot.mazeUpdated(to: maze)
			}
		}
		updateStats();
	}
	
	
	public func updateStats() {
		
		guard let maze = self.maze else {
			return
		}
		
		var out = "";
		
		
		if let seed = maze.mazeSeed {
			out += "Maze Seed: \(seed)\n"
		}
		
		for robot in self.robots {
			out += "------------\n"
			out += "Robot Name: \(robot.name)\n"
			out += "Robot Score: \(robot.score)\n"
			out += "Robot Status: \(robot.status)\n"
			out += "Number Of Moves: \(robot.numberOfMoves)\n"
			out += "Number Of Turns: \(robot.numberOfTurns)\n"
			
			
			out += "Robot Position: \(robot.robotPos)\n"
			out += "Robot Direction: \(robot.robotDirection)\n"
			
		}
		
		
		self.delegate?.mazeView(self, didUpdateStats: out)
	}
	
	public func clearMaze() {
		for m in mazeBlocks {
			for n in m {
				n.removeFromSuperview()
			}
		}
		mazeBlocks.removeAll()
		
	}
	
	open override func layoutSubviews() {
		
		super.layoutSubviews()
		for (y,m) in mazeBlocks.enumerated() {
			for (x,n) in m.enumerated() {
				n.frame = getPosition(x, y)
			}
		}
		
		for r in robotViews {
			if r.robot.status != .running {
				r.frame = getPosition(r.robot.robotPos.x, r.robot.robotPos.y);
			}
		}
		
	}
	
	
	
	private func getPosition(_ xpos: Int, _ ypos: Int, size: CGFloat = -1) -> CGRect {
		guard let maze = self.maze else {
			return .zero
		}
		
		let cellWidth = self.frame.width / maze.size.cgSize.width;
		let cellHeight = self.frame.height / maze.size.cgSize.height;
		if size == -1 {
			return CGRect(x: (CGFloat(xpos) * cellWidth), y: (CGFloat(ypos) * cellHeight), width: cellWidth, height: cellHeight);
		} else {
			return CGRect(x: (CGFloat(xpos) * cellWidth), y: (CGFloat(ypos) * cellHeight), width: size, height: size);
		}
	}
	
}

