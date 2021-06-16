//
//  DrawTogetherWWDC21App.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 14/06/2021.
//

import SwiftUI

@main
struct DrawTogetherWWDC21App: App {
    var body: some Scene {
        WindowGroup {
			if #available(iOS 15.0, *) {
				ContentView()
			} else {
				// Fallback on earlier versions
				
				Rectangle()
					.fill(.gray)
					.frame(width: 20, height: 20)
			}
        }
    }
}
