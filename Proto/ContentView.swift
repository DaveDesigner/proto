//
//  ContentView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0
    @State private var showTitle = true
    
    var body: some View {
        TabView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Title as part of scrolling content
                        Text("Home")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                            .padding(.top, 61)
                        
                        // Feed image scaled to fill width and fully scrollable
                        if let _ = UIImage(named: "Feed") {
                            Image("Feed")
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
                                    Text("Feed Image")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        }   
                    }
                }
                .scrollContentBackground(.hidden)
                .ignoresSafeArea()
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    showTitle = value <= 0
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // Add new item action here
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // Add user profile action here
                        }) {
                            Image(systemName: "person")
                                .font(.title2)
                        }
                    }
                }
                .toolbar(showTitle ? .visible : .hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            Text("Notifications View")
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Notifications")
                }
            
            Text("Messages View")
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
                }
        }
        .background(.ultraThinMaterial)
    }
}

// Preference key to track scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// ScrollView extension to track offset
extension ScrollView {
    func trackScrollOffset() -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            }
        )
    }
}

#Preview {
    ContentView()
}
