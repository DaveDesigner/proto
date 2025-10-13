//
//  PostDetails.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PostDetails: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isToolbarVisible = true
    @State private var isTabBarVisible = false
    @State private var hasUserToggled = false

    @State private var commentText = AttributedString("")
    @FocusState private var isCommentFieldFocused: Bool
    @State private var showCommentMode = false
    @State private var shouldMaintainFocus = false
    @State private var isHeartFilled = false
    @State private var showSettingsSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false
    // Computed property to help with toolbar updates
    private var toolbarState: String {
        "\(showCommentMode)-\(commentText.characters.isEmpty)-\(isCommentFieldFocused)"
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
                }
            }
            .onAppear {
                // Only reset to default state if user hasn't manually toggled
                if !hasUserToggled {
                    isToolbarVisible = true
                    isTabBarVisible = false
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        // Immediately return to default state when scrolling starts
                        // This also resets the user toggle flag so onAppear will work correctly next time
                        hasUserToggled = false
                        isToolbarVisible = true
                        isTabBarVisible = false
                        
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
                        // Format menu button
                        MessageComposerFormatMenu(text: $commentText)
                        
                        Spacer()
                        
                        // MessageComposer input field
                        MessageComposer(
                            text: $commentText,
                            isFocused: $isCommentFieldFocused,
                            placeholder: "Add comment",
                            onSubmit: {
                                // Submit comment
                                commentText = AttributedString("")
                                isCommentFieldFocused = false
                                showCommentMode = false
                                shouldMaintainFocus = false
                            }
                        )
                    }
                } else {
                    // Show toolbar when not in comment mode
                    ToolbarItemGroup(placement: .bottomBar) {
                        // Tabbar toggle button
                        Button(action: {
                            // Mark that user has manually toggled
                            hasUserToggled = true
                            // Toggle: when tab bar is visible, hide bottom toolbar; when tab bar is hidden, show bottom toolbar
                            isTabBarVisible.toggle()
                            // Bottom toolbar visibility is opposite of tab bar visibility
                            isToolbarVisible = !isTabBarVisible
                        }) {
                            Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        // Fake text field
                        Text("Add comment")
                            .font(.body)
                            .foregroundStyle(.tertiary)
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
