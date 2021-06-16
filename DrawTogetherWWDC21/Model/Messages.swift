//
//  Messages.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 15/06/2021.
//

import Foundation
import SwiftUI

struct UpsertStrokeMessage: Codable {
	let id: UUID
	let color: String
	let point: CGPoint
}
