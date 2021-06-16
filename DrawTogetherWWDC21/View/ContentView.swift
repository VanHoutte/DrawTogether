//
//  ContentView.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
	@StateObject var canvas = Canvas()
	
    var body: some View {
		VStack {
			HStack {
				Spacer()
				
				Rectangle()
					.fill(Color(canvas.strokeColor))
					.frame(width: 20, height: 20)
			}
			.padding()
			
			CanvasView(canvas: canvas)
			
//			CanvasView(canvas: canvas,
//					   currentStroke: $currentStroke
//					   drawings: $drawings,
//					   color: $color,
//					   lineWidth: $lineWidth
//			)
			
			ControlBar(canvas: canvas)
				.padding()
		}
		.task {
			for await session in DrawTogether.sessions() {
				canvas.configureGroupSession(groupSession: session)
			}
		}
    }
}
