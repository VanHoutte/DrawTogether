//
//  Canvas.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import Foundation
import Combine
import SwiftUI
import GroupActivities

@available(iOS 15.0, *)
@MainActor
class Canvas: ObservableObject {
	@Published var strokes = [Stroke]()
	@Published var activeStroke: Stroke?
	let strokeColor = UIColor.random()
	
	var subscriptions = Set<AnyCancellable>()
	var tasks = Set<Task.Handle<Void, Never>>()
	
	func addPointToActiveStroke(point: CGPoint) {
		let stroke: Stroke
		if let activeStroke = activeStroke {
			stroke = activeStroke
		} else {
			stroke = Stroke(color: strokeColor)
			activeStroke = stroke
		}
		
		stroke.points.append(point)
		
		if let messenger = messenger {
			async {
				do {
					try await messenger.send(UpsertStrokeMessage(id: stroke.id, color: strokeColor.toHexString(), point: point))
				} catch {
					// handle error
				}
			}
		}
		
		self.objectWillChange.send()
	}
	
	func finishStroke() {
		guard let activeStroke = activeStroke else {
			return
		}
		
		strokes.append(activeStroke)
		self.activeStroke = nil
	}
	
	func reset() {
		strokes = []
		
		messenger = nil
		tasks.forEach { $0.cancel() }
		tasks = []
		subscriptions = []
		if groupSession != nil {
			groupSession?.leave()
			groupSession = nil
			DrawTogether().activate()
		}
	}
	
	var pointCount: Int {
		return strokes.reduce(0) { $0 + $1.points.count}
	}
	
	@Published var groupSession: GroupSession<DrawTogether>?
	var messenger: GroupSessionMessenger?
	
	func configureGroupSession(groupSession: GroupSession<DrawTogether>) {
		reset()
		
		self.groupSession = groupSession
		let messenger = GroupSessionMessenger(session: groupSession)
		self.messenger = messenger
		
		let strokeTask = detach { [weak self] in
			for await (message, _) in messenger.messages(of: UpsertStrokeMessage.self) {
				await self?.handle(message: message)
			}
		}
		
		tasks.insert(strokeTask)
		groupSession.join()
	}
	
	func handle(message: UpsertStrokeMessage) {
		if let stroke = strokes.first(where: { $0.id == message.id }) {
			stroke.points.append(message.point)
		} else {
			let stroke = Stroke(id: message.id, color: UIColor(message.color))
			stroke.points.append(message.point)
			strokes.append(stroke)
		}
		
		self.objectWillChange.send()
	}
}

extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let a, r, g, b: UInt64
		switch hex.count {
		case 3: // RGB (12-bit)
			(a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
		case 6: // RGB (24-bit)
			(a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
		case 8: // ARGB (32-bit)
			(a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
		default:
			(a, r, g, b) = (1, 1, 1, 0)
		}
		
		self.init(
			.sRGB,
			red: Double(r) / 255,
			green: Double(g) / 255,
			blue:  Double(b) / 255,
			opacity: Double(a) / 255
		)
	}
}
extension CGFloat {
	static func random() -> CGFloat {
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
}
extension UIColor {
	static func random() -> UIColor {
		return UIColor(
			red:   .random(),
			green: .random(),
			blue:  .random(),
			alpha: 1.0
		)
	}
}
								
extension UIColor {
				convenience init(_ hex: String, alpha: CGFloat = 1.0) {
					var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
					
					if cString.hasPrefix("#") { cString.removeFirst() }
					
					if cString.count != 6 {
						self.init("ff0000") // return red color for wrong hex input
						return
					}
					
					var rgbValue: UInt64 = 0
					Scanner(string: cString).scanHexInt64(&rgbValue)
					
					self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
							  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
							  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
							  alpha: alpha)
				}
}
								extension UIColor {
				func toHexString() -> String {
					var r:CGFloat = 0
					var g:CGFloat = 0
					var b:CGFloat = 0
					var a:CGFloat = 0
					
					getRed(&r, green: &g, blue: &b, alpha: &a)
					
					let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
																						
																						return String(format:"#%06x", rgb)
				}
			}
