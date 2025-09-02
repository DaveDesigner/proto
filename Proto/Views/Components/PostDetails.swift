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
                        
                        Button(action: {}) {
                            Label("11 comments", systemImage: "message")
                        }
                        
                        Divider()
                        
                        Button(action: {}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {}) {
                            Label("Bookmark", systemImage: "bookmark")
                        }
                        
                        Button(action: {}) {
                            Label("Follow", systemImage: "bell")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        // Mark that user has manually toggled
                        hasUserToggled = true
                        // Toggle: when tab bar is visible, hide bottom toolbar; when tab bar is hidden, show bottom toolbar
                        isTabBarVisible.toggle()
                        // Bottom toolbar visibility is opposite of tab bar visibility
                        isToolbarVisible = !isTabBarVisible
                    }) {
                        Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer(minLength: 16)
                    TextField("Add comment", text: .constant(""))
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 8)
                    Spacer(minLength: 16)
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar(isToolbarVisible ? .visible : .hidden, for: .bottomBar)
                .animation(.easeInOut(duration: 0.3), value: isToolbarVisible)
            .toolbar(isTabBarVisible ? .visible : .hidden, for: .tabBar)
                .animation(.easeInOut(duration: 0.3), value: isTabBarVisible)
        }
    }
}

#Preview {
    PostDetails()
}
