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
/// - Flexible action system for toolbar buttons
///
/// Usage examples:
/// ```swift
/// // Default: medium and large detents, visible drag indicator, automatic Liquid Glass
/// SheetTemplate(title: "My Sheet") {
///     YourContent()
/// }
///
/// // With a primary action (Save, Send, etc.)
/// SheetTemplate(title: "Settings", primaryAction: .init(
///     title: "Save",
///     action: { saveSettings() },
///     isDisabled: { !hasChanges }
/// )) {
///     YourContent()
/// }
///
/// // With icon actions
/// SheetTemplate(title: "Invite", primaryAction: .init(
///     iconName: "arrow.up",
///     action: { sendInvite() }
/// )) {
///     YourContent()
/// }
///
/// // With both primary and secondary actions
/// SheetTemplate(title: "Edit", primaryAction: .init(
///     title: "Save",
///     action: { save() }
/// ), secondaryAction: .init(
///     title: "Cancel",
///     action: { dismiss() }
/// )) {
///     YourContent()
/// }
/// ```

/// Represents a toolbar action with title or icon, action closure, and optional disabled state
struct SheetAction {
    let title: String?
    let iconName: String?
    let action: () -> Void
    let isDisabled: () -> Bool
    
    init(title: String, action: @escaping () -> Void, isDisabled: @escaping () -> Bool = { false }) {
        self.title = title
        self.iconName = nil
        self.action = action
        self.isDisabled = isDisabled
    }
    
    init(iconName: String, action: @escaping () -> Void, isDisabled: @escaping () -> Bool = { false }) {
        self.title = nil
        self.iconName = iconName
        self.action = action
        self.isDisabled = isDisabled
    }
}

struct SheetTemplate<Content: View>: View {
    let detents: Set<PresentationDetent>
    let dragIndicator: Visibility
    let title: String
    let content: Content
    let primaryAction: SheetAction?
    let secondaryAction: SheetAction?
    let topRightAction: (() -> AnyView)? // Legacy support
    let trailingToolbarAction: (() -> AnyView)? // Legacy support
    @State private var selectedDetent: PresentationDetent
    @State private var buttonUpdateTrigger = false

    init(
        title: String,
        detents: Set<PresentationDetent> = [.medium, .large],
        dragIndicator: Visibility = .visible,
        primaryAction: SheetAction? = nil,
        secondaryAction: SheetAction? = nil,
        topRightAction: (() -> AnyView)? = nil, // Legacy support
        trailingToolbarAction: (() -> AnyView)? = nil, // Legacy support
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.detents = detents
        self.dragIndicator = dragIndicator
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.topRightAction = topRightAction
        self.trailingToolbarAction = trailingToolbarAction
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
                    
                    // New action system
                    if let primaryAction = primaryAction {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if primaryAction.isDisabled() {
                                Button(action: primaryAction.action) {
                                    if let iconName = primaryAction.iconName {
                                        Image(systemName: iconName)
                                            .font(.system(size: 16, weight: .medium))
                                    } else if let title = primaryAction.title {
                                        Text(title)
                                    }
                                }
                                .disabled(true)
                                //.buttonStyle(.plain)
                                .id("primaryAction-\(primaryAction.isDisabled())-\(buttonUpdateTrigger)")
                            } else {
                                Button(action: primaryAction.action) {
                                    if let iconName = primaryAction.iconName {
                                        Image(systemName: iconName)
                                            .font(.system(size: 16, weight: .medium))
                                    } else if let title = primaryAction.title {
                                        Text(title)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.primary)
                                .id("primaryAction-\(primaryAction.isDisabled())-\(buttonUpdateTrigger)")
                            }
                        }
                        .sharedBackgroundVisible()
                    }
                    
                    if let secondaryAction = secondaryAction {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: secondaryAction.action) {
                                if let iconName = secondaryAction.iconName {
                                    Image(systemName: iconName)
                                        .font(.system(size: 16, weight: .medium))
                                } else if let title = secondaryAction.title {
                                    Text(title)
                                }
                            }
                            .disabled(secondaryAction.isDisabled())
                        }
                    }
                    
                    // Legacy support
                    if let trailingToolbarAction = trailingToolbarAction {
                        ToolbarItem() {
                            trailingToolbarAction()
                        }
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
        primaryAction: SheetAction? = nil,
        secondaryAction: SheetAction? = nil,
        topRightAction: (() -> AnyView)? = nil, // Legacy support
        trailingToolbarAction: (() -> AnyView)? = nil, // Legacy support
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, detents: Set(detents), dragIndicator: dragIndicator, primaryAction: primaryAction, secondaryAction: secondaryAction, topRightAction: topRightAction, trailingToolbarAction: trailingToolbarAction, content: content)
    }
    
    init(
        title: String,
        detent: PresentationDetent,
        dragIndicator: Visibility = .visible,
        primaryAction: SheetAction? = nil,
        secondaryAction: SheetAction? = nil,
        topRightAction: (() -> AnyView)? = nil, // Legacy support
        trailingToolbarAction: (() -> AnyView)? = nil, // Legacy support
        @ViewBuilder content: () -> Content
    ) {
        self.init(title: title, detents: [detent], dragIndicator: dragIndicator, primaryAction: primaryAction, secondaryAction: secondaryAction, topRightAction: topRightAction, trailingToolbarAction: trailingToolbarAction, content: content)
    }
}

#Preview {
    SheetTemplate(
        title: "Sheet Template Preview",
        primaryAction: .init(
            title: "Save",
            action: { print("Save tapped") },
            isDisabled: { false }
        ),
        secondaryAction: .init(
            title: "Cancel",
            action: { print("Cancel tapped") }
        )
    ) {
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
