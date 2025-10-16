//
//  PostDetails.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PostDetails: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isTabBarVisible = false
    @State private var hasUserToggled = false

    @State private var commentText = AttributedString("")
    @State private var commentSelection = AttributedTextSelection()
    @State private var selectedRange: Range<AttributedString.Index>?
    @FocusState private var isCommentFieldFocused: Bool
    @State private var showCommentMode = false
    @State private var shouldMaintainFocus = false
    @State private var isHeartFilled = false
    @State private var showSettingsSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false

    // Computed property to check if text is selected (iOS 26 AttributedTextSelection)
    private var hasTextSelection: Bool {
        guard case .ranges(let ranges) = commentSelection.indices(in: commentText) else {
            return false // insertionPoint case = just cursor, no selection
        }
        return !ranges.isEmpty
    }

    // Computed property to help with toolbar updates
    private var toolbarState: String {
        "\(showCommentMode)-\(commentText.characters.isEmpty)-\(isCommentFieldFocused)-\(hasTextSelection)"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Post image scaled to fill width and fully scrollable
                    if let _ = UIImage(named: "Post") {
                        Image("Post")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else {
                        // Fallback if image not found
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(height: 400)
                            .overlay(
                                Text("Post Image")
                                    .font(.headline)
                            )
                            .padding(.horizontal)
                    }   
                }
            }
            .onTapGesture {
                // Dismiss comment mode when tapping outside
                if showCommentMode {
                    showCommentMode = false
                    isCommentFieldFocused = false
                    shouldMaintainFocus = false
                    // Return to default state - hide tab bar (toolbar will show automatically)
                    isTabBarVisible = false
                }
            }
            .onAppear {
                // Only reset to default state if user hasn't manually toggled
                if !hasUserToggled {
                    isTabBarVisible = false
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { _ in
                        // Immediately return to default state when scrolling starts
                        // This also resets the user toggle flag so onAppear will work correctly next time
                        hasUserToggled = false
                        isTabBarVisible = false
                        showCommentMode = false
                        // Return to default state (toolbar will show automatically when tab bar is hidden)
                        
                        // Also dismiss keyboard and reset comment mode when scrolling
                        if isCommentFieldFocused {
                            isCommentFieldFocused = false
                            showCommentMode = false
                            shouldMaintainFocus = false
                        }
                    }
            )

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {}) {
                            Label("Summarize", systemImage: "sparkle")
                                .tint(Color(red: 150/255, green: 118/255, blue: 248/255))
                        }
                        
                        Divider()
                        
                        Button(action: {}) {
                            Label("23 likes", systemImage: "heart")
                        }
                        .tint(.primary)
                        
                        Button(action: {}) {
                            Label("11 comments", systemImage: "message")
                        }
                        .tint(.primary)
                        
                        Divider()
                        
                        Button(action: {}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        .tint(.primary)
                        
                        Button(action: {}) {
                            Label("Bookmark", systemImage: "bookmark")
                        }
                        .tint(.primary)
                        
                        Button(action: {}) {
                            Label("Follow", systemImage: "bell")
                        }
                        .tint(.primary)
                        
                        Divider()
                        
                        Button(action: {
                            showEditSheet = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.primary)
                        
                        Button(action: {
                            showSettingsSheet = true
                        }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .tint(.primary)
                        
                        Button(role: .destructive, action: {
                            showDeleteConfirmation = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                if showCommentMode {
                    // Show MessageComposer when in comment mode
                    ToolbarItemGroup(placement: .bottomBar) {
                        // Conditional menu button - formatting menu when text is selected, full menu otherwise
                        if hasTextSelection {
                            MessageComposerFormattingMenu(text: $commentText, selection: $commentSelection)
                        } else {
                            MessageComposerFormatMenu(text: $commentText, selection: $commentSelection)
                        }

                        Spacer()

                        // MessageComposer input field
                        MessageComposer(
                            text: $commentText,
                            selection: $commentSelection,
                            isFocused: $isCommentFieldFocused,
                            placeholder: "Add comment",
                            onSubmit: {
                                // Submit comment
                                commentText = AttributedString("")
                                commentSelection = AttributedTextSelection()
                                isCommentFieldFocused = false
                                showCommentMode = false
                                shouldMaintainFocus = false
                            },
                            onDragStart: {
                                // Handle drag start on message composer - return to default state
                                hasUserToggled = false
                                isTabBarVisible = false
                                showCommentMode = false
                                isCommentFieldFocused = false
                                shouldMaintainFocus = false
                                // Return to default state (toolbar will show automatically when tab bar is hidden)
                            }
                        )
                    }
                } else if !isTabBarVisible {
                    // Show toolbar when not in comment mode and tab bar is not visible
                    ToolbarItemGroup(placement: .bottomBar) {
                        // Tabbar toggle button
                        Button(action: {
                            // Mark that user has manually toggled
                            hasUserToggled = true
                            // Toggle tab bar visibility
                            isTabBarVisible.toggle()
                            // Toolbar visibility is now controlled by the SwiftUI toolbar modifier
                        }) {
                            Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        // Fake text field
                        Text(commentText.characters.isEmpty ? "Add comment" : String(commentText.characters.prefix(50)) + (commentText.characters.count > 50 ? "..." : ""))
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                            .background(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldMaintainFocus = true
                                showCommentMode = true
                                // Immediately focus the text field when entering comment mode
                                DispatchQueue.main.async {
                                    isCommentFieldFocused = true
                                }
                            }
                        
                        Spacer()
                        
                        // Heart button
                        Button(action: {
                            isHeartFilled.toggle()
                        }) {
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .toolbar(isTabBarVisible ? .visible : .hidden, for: .tabBar)
                .animation(.easeInOut(duration: 0.3), value: isTabBarVisible)
            .sheet(isPresented: $showSettingsSheet) {
                PostSettingsSheet()
            }
            .sheet(isPresented: $showEditSheet) {
                // Placeholder for edit sheet - can be implemented later
                Text("Edit Post")
                    .font(.title)
                    .padding()
            }
            .confirmationDialog("Delete Post", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    // Handle delete action
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this post? This action cannot be undone.")
            }
        }
    }
}

#Preview {
    PostDetails()
}
