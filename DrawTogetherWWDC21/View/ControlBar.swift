//
//  ControlBar.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct ControlBar: View {
	@ObservedObject var canvas: Canvas
	
	var body: some View {
		HStack {
			Button {
				DrawTogether().activate()
			} label: {
				Image(systemName: "person.2.fill")
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(50)
			
			Spacer()
			
			Button {
				canvas.reset()
			} label: {
				Image(systemName: "trash.fill")
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(50)
		}
	}
}
