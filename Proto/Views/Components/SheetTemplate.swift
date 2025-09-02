//
//  SheetTemplate.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// A reusable sheet template that provides consistent presentation modifiers
/// across all sheets in the app. Uses iOS 26's automatic Liquid Glass appearance.
/// 
/// Key features:
/// - Automatically applies iOS 26 Liquid Glass background when using partial detents
/// - Eliminates duplication of presentation modifiers
/// - Ensures consistent behavior across all sheets
///
/// Usage examples:
/// ```swift
/// // Default: medium and large detents, visible drag indicator, automatic Liquid Glass
/// SheetTemplate {
///     YourContent()
/// }
///
/// // Custom detents - still gets automatic Liquid Glass
/// SheetTemplate(detents: .large) {
///     YourContent()
/// }
///
/// // Custom detents and hidden drag indicator
/// SheetTemplate(detents: .medium, .large, dragIndicator: .hidden) {
///     YourContent()
/// }
/// ```
struct SheetTemplate<Content: View>: View {
    let detents: Set<PresentationDetent>
    let dragIndicator: Visibility
    let content: Content
    @State private var selectedDetent: PresentationDetent

    init(
        detents: Set<PresentationDetent> = [.medium, .large],
        dragIndicator: Visibility = .visible,
        @ViewBuilder content: () -> Content
    ) {
        self.detents = detents
        self.dragIndicator = dragIndicator
        self.content = content()
        // Prefer .medium if available, else .large, else any provided detent (or .medium as a fallback)
        let initial: PresentationDetent
        if detents.contains(.medium) {
            initial = .medium
        } else if detents.contains(.large) {
            initial = .large
        } else {
            initial = detents.first ?? .medium
        }
        self._selectedDetent = State(initialValue: initial)
    }
    
    var body: some View {
        content
            .presentationDetents(detents, selection: $selectedDetent)
            .presentationDragIndicator(dragIndicator)
            .presentationBackgroundInteraction(.enabled(upThrough: .medium)) // Reduce dimming overlay
            // Note: No presentationBackground() - let iOS 26 apply Liquid Glass automatically
    }
}

// Convenience initializers for common use cases
extension SheetTemplate {
    init(
        detents: PresentationDetent...,
        dragIndicator: Visibility = .visible,
        @ViewBuilder content: () -> Content
    ) {
        self.init(detents: Set(detents), dragIndicator: dragIndicator, content: content)
    }
    
    init(
        detent: PresentationDetent,
        dragIndicator: Visibility = .visible,
        @ViewBuilder content: () -> Content
    ) {
        self.init(detents: [detent], dragIndicator: dragIndicator, content: content)
    }
}

#Preview {
    SheetTemplate {
        VStack(spacing: 20) {
            Text("Sheet Template Preview")
                .font(.title2.bold())
            
            Text("This sheet template uses iOS 26's automatic Liquid Glass appearance with consistent presentation modifiers.")
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
