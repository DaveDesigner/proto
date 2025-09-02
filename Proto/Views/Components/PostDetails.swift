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
    @State private var scrollTimer: Timer?
    
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
                // Reset visibility when view appears
                isToolbarVisible = true
                isTabBarVisible = false
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        // Cancel any existing timer
                        scrollTimer?.invalidate()
                        
                        // Start a new timer
                        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                            // Always collapse to default state on scroll
                            isToolbarVisible = true
                            isTabBarVisible = false
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
