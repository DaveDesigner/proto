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
    let title: String
    let content: Content
    let topRightAction: (() -> AnyView)?
    @State private var selectedDetent: PresentationDetent

    init(
        title: String,
        detents: Set<PresentationDetent> = [.medium, .large],
        dragIndicator: Visibility = .visible,
        topRightAction: (() -> AnyView)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.detents = detents
        self.dragIndicator = dragIndicator
        self.topRightAction = topRightAction
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
        NavigationStack {
            ZStack {
                ScrollView {
                    content
                }
                .scrollIndicators(.hidden)
                .navigationTitle(" ")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(" ")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                    }
                }
                //.toolbarBackground(.glassEffect, for: .navigationBar)
                //.toolbarBackground(.visible, for: .navigationBar)
                
                // Fixed overlay title and top-right action
                VStack {
                    HStack {
                        Text(title)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .padding(.leading, 20)
                        Spacer()
                        if let topRightAction = topRightAction {
                            topRightAction()
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, -38) // Negative margin to move up into toolbar area
                    Spacer()
                }
            }
        }
        .presentationDetents(detents, selection: $selectedDetent)
        .presentationDragIndicator(dragIndicator)
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
    }
}

// Convenience initializers for common use cases
extension SheetTemplate {
    init(
        title: String,
        detents: PresentationDetent...,
        dragIndicator: Visibility = .visible,
        topRightAction: (() -> AnyView)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, detents: Set(detents), dragIndicator: dragIndicator, topRightAction: topRightAction, content: content)
    }
    
    init(
        title: String,
        detent: PresentationDetent,
        dragIndicator: Visibility = .visible,
        topRightAction: (() -> AnyView)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, detents: [detent], dragIndicator: dragIndicator, topRightAction: topRightAction, content: content)
    }
}

#Preview {
    SheetTemplate(title: "Sheet Template Preview") {
        VStack(spacing: 20) {
            Text("This sheet template uses iOS 26's automatic Liquid Glass appearance with consistent presentation modifiers.")
                .multilineTextAlignment(.center)
            
            ForEach(0..<10, id: \.self) { index in
                Text("Scrollable content item \(index + 1)")
                    .padding()
            }
        }
        .padding()
    }
}
