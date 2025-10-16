//
//  View+Extensions.swift
//  Proto
//
//  Created by Dave Morgan on 18/09/2025.
//

import SwiftUI

// MARK: - Standard Padding
extension View {
    /// Applies the standard horizontal padding (16pt) used throughout the app
    public func standardHorizontalPadding() -> some View {
        self.padding(.horizontal, 16)
    }
    
    /// Alias for matchedGeometryEffect for lightbox transitions
    public func matchedTransitionSource(id: String, in namespace: Namespace.ID) -> some View {
        self.matchedGeometryEffect(id: id, in: namespace)
    }
}

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
    
    @ToolbarContentBuilder
    public func sharedBackgroundVisible() -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            // Show the iOS 26 glass effect for the toolbar content
            self
                .sharedBackgroundVisibility(.visible)
        } else {
            self
        }
    }
}
