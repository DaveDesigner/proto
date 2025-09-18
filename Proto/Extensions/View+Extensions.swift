//
//  View+Extensions.swift
//  Proto
//
//  Created by Dave Morgan on 18/09/2025.
//

import SwiftUI

// MARK: - Shared Background Visibility
extension ToolbarContent {
    @ToolbarContentBuilder
    public func sharedBackgroundHidden() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            // Remove the iOS 26 glass effect from the toolbar content
            self
                .sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}
