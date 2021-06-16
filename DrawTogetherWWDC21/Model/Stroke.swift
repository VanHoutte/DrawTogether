//
//  Stroke.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import Foundation
import SwiftUI
import Combine

class Stroke: Identifiable, ObservableObject {
	let id: UUID
	let color: UIColor
	@Published var points: [CGPoint] = [CGPoint]()
		
	var subscriptions = Set<AnyCancellable>()
	init(id: UUID = UUID(), color: UIColor = .red, points: [CGPoint] = []) {
		self.id = id
		self.color = color
		self.points = points
		
//		$points
//			.print("points")
//			.sink { points in
////				print("Get points: \(points)")
//			}
//			.store(in: &subscriptions)
	}
}

extension Array where Element == CGPoint {
	var path: Path {
		var path = Path()

		if self.count > 1 {
			for i in 0..<self.count-1 {
				let current = self[i]
				let next = self[i+1]
				path.move(to: current)
				path.addLine(to: next)
			}
		}
		
		return path
	}
}

extension Color {
	static var random: Color {
		return Color(red: .random(in: 0...1),
					 green: .random(in: 0...1),
					 blue: .random(in: 0...1))
	}
}
