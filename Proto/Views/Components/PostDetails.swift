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

    @State private var commentText = ""
    @FocusState private var isCommentFieldFocused: Bool
    @State private var showCommentMode = false
    @State private var shouldMaintainFocus = false
    @State private var isHeartFilled = false
    @State private var showSettingsSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false
    
    // Computed property to help with toolbar updates
    private var toolbarState: String {
        "\(showCommentMode)-\(commentText.isEmpty)-\(isCommentFieldFocused)"
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
                            showSettingsSheet = true
                        }) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .tint(.primary)
                        
                        Button(action: {
                            showEditSheet = true
                        }) {
                            Label("Edit", systemImage: "pencil")
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
                ToolbarItemGroup(placement: .bottomBar) {
                    // Allow toolbar to expand with content height
                                        // Leading button - always present, changes content based on state
                    Group {
                        if showCommentMode {
                            // Show + button when comment field is active
                            Menu {
                                Button(action: {
                                    // Tag content
                                    commentText += " #"
                                }) {
                                    Label("Tag content", systemImage: "number")
                                }
                                .tint(.primary)
                                
                                Button(action: {
                                    // Mention
                                    commentText += " @"
                                }) {
                                    Label("Mention", systemImage: "at")
                                }
                                .tint(.primary)
                                
                                Divider()
                                
                                Button(action: {
                                    // Image
                                }) {
                                    Label("Image", systemImage: "photo")
                                }
                                .tint(.primary)
                                
                                Button(action: {
                                    // GIF
                                }) {
                                    Label("GIF", systemImage: "rectangle.3.group")
                                }
                                .tint(.primary)
                                
                                Button(action: {
                                    // Attach
                                }) {
                                    Label("Attach", systemImage: "paperclip")
                                }
                                .tint(.primary)
                                
                                Button(action: {
                                    // Record
                                }) {
                                    Label("Record", systemImage: "waveform")
                                }
                                .tint(.primary)
                            } label: {
                                Image(systemName: "plus")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            // Show tabbar toggle when comment field is inactive
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
                    }
                    }
                    
                    // Consistent spacing - let SwiftUI handle it naturally
                    Spacer(minLength: 16)
                    
                    // Comment input area - always present, changes content based on state
                    if showCommentMode {
                        // Real text editor when in comment mode - supports multiple lines
                        HStack(alignment: .bottom, spacing: 0) {
                            TextEditor(text: $commentText)
                                .font(.body) // Ensure regular weight
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4) // Add vertical padding for better appearance
                                .background(.clear) // Transparent background to show toolbar glass
                                .scrollContentBackground(.hidden) // Hide scroll background
                                .focused($isCommentFieldFocused)
                                .onAppear {
                                    // Auto-focus the text field when it appears
                                    if shouldMaintainFocus {
                                        DispatchQueue.main.async {
                                            isCommentFieldFocused = true
                                        }
                                    }
                                }
                            
                            // Submit button - only show when there's text
                            if !commentText.isEmpty {
                                Button(action: {
                                    // Submit comment
                                    commentText = ""
                                    isCommentFieldFocused = false
                                    showCommentMode = false
                                    shouldMaintainFocus = false
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                            } else {
                                // Disabled submit button when no text
                                Button(action: {}) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.tertiary)
                                }
                                .disabled(true)
                            }
                        }
                    } else {
                        // Fake text field when not in comment mode
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("Add comment")
                                .font(.body) // Ensure regular weight
                                .foregroundStyle(.tertiary) // Match text field placeholder color
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 8) // Add padding to match text field
                                .contentShape(Rectangle()) // Make entire area tappable
                                .onTapGesture {
                                    shouldMaintainFocus = true
                                    showCommentMode = true
                                }
                        }
                    }

                    
                    Spacer(minLength: 16)
                    
                    // Trailing button area - always present to maintain layout structure
                    Group {
                        if !showCommentMode {
                            Button(action: {
                                isHeartFilled.toggle()
                            }) {
                                Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        } else {
                        }
                    }
                }
            }
            .toolbar(isToolbarVisible ? .visible : .hidden, for: .bottomBar)
                .animation(.easeInOut(duration: 0.3), value: isToolbarVisible)
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
