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
    @State private var lastScrollOffset: CGFloat = 0
    @State private var scrollDirection: ScrollDirection = .none
    @State private var isUserScrolling = false
    
    enum ScrollDirection {
        case up, down, none
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
            .onAppear {
                // Reset visibility when view appears
                isToolbarVisible = true
                isTabBarVisible = false
                isUserScrolling = false
                scrollDirection = .none
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
            )
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                handleScrollOffsetChange(value)
            }

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
                        toggleToolbarState()
                    }) {
                        Image(systemName: isTabBarVisible ? "rectangle.on.rectangle.angled" : "rectangle.fill.on.rectangle.angled.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                            .scaleEffect(isTabBarVisible ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: isTabBarVisible)
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
    
    // MARK: - Helper Methods
    
    private func toggleToolbarState() {
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isTabBarVisible.toggle()
            isToolbarVisible = !isTabBarVisible
        }
    }
    
    private func handleScrollOffsetChange(_ offset: CGFloat) {
        let threshold: CGFloat = 10.0
        let delta = offset - lastScrollOffset
        
        // Determine scroll direction
        if abs(delta) > threshold {
            if delta > 0 {
                scrollDirection = .up
            } else {
                scrollDirection = .down
            }
            lastScrollOffset = offset
        }
        
        // Cancel any existing timer
        scrollTimer?.invalidate()
        
        // Start a new timer for scroll end detection
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            handleScrollEnd()
        }
    }
    
    private func handleScrollEnd() {
        // Only auto-hide toolbar when scrolling down significantly
        if scrollDirection == .down && lastScrollOffset < -50 {
            withAnimation(.easeInOut(duration: 0.3)) {
                isToolbarVisible = false
                isTabBarVisible = true
            }
        } else if scrollDirection == .up {
            // Show toolbar when scrolling up
            withAnimation(.easeInOut(duration: 0.3)) {
                isToolbarVisible = true
                isTabBarVisible = false
            }
        }
        
        scrollDirection = .none
        isUserScrolling = false
    }
}

// MARK: - Scroll Offset Preference Key

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    PostDetails()
}
