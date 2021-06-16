//
//  CanvasView.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct CanvasView: View {
	@ObservedObject var canvas: Canvas
			
	var gesture: some Gesture {
		DragGesture()
			.onChanged({ (value) in
				canvas.addPointToActiveStroke(point: value.location)
			})
			.onEnded({ (value) in
				canvas.finishStroke()
			})
	}
	
	var body: some View {
		SwiftUI.Canvas(rendersAsynchronously: false) { context, size in
			for stroke in self.canvas.strokes {
				context.stroke(stroke.points.path, with: .color(Color(canvas.strokeColor)), lineWidth: 2.0)
			}
			
			if let activeStrokePoints = self.canvas.activeStroke?.points {
				context.stroke(activeStrokePoints.path, with: .color(Color(canvas.strokeColor)), lineWidth: 2.0)
			}
		}
		.frame(width: 400, height: 600)
		.background(Color(white: 0.95))
		.gesture(gesture)
	}
	
	private func add(stroke: Stroke, toPath path: inout Path) {
		let points = stroke.points
		if points.count > 1 {
			for i in 0..<points.count-1 {
				let current = points[i]
				let next = points[i+1]
				path.move(to: current)
				path.addLine(to: next)
			}
		}
	}
	
	private func add(points: [CGPoint], toPath path: inout Path) {
		if points.count > 1 {
			for i in 0..<points.count-1 {
				let current = points[i]
				let next = points[i+1]
				path.move(to: current)
				path.addLine(to: next)
			}
		}
	}
}
