//
//  DrawTogether.swift
//  DrawTogetherWWDC21
//
//  Created by Mathias Van Houtte on 15/06/2021.
//

import Foundation
import GroupActivities

@available(iOS 15, *)
struct DrawTogether: GroupActivity {
	var metadata: GroupActivityMetadata {
		var metadata = GroupActivityMetadata()
		metadata.title = NSLocalizedString("Draw Together", comment: "Title of the group Activity")
		metadata.type = .generic
		return metadata
	}
}
