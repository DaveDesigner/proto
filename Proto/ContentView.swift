//
//  ContentView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Title as part of scrolling content
                            Text("Community")
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
                    .scrollEdgeEffectHidden(false)
                    .ignoresSafeArea()
                    .toolbar {
                        ToolbarItem() {
                                Button(action: {
                                // Add new item action here
                                }) {
                                    Image(systemName: "plus")
                                    .font(.body)
                                }
                        }
                        ToolbarSpacer()
                        
                        ToolbarItem() {
                            Image("Avatar")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                                .onTapGesture {
                                    // Add user profile action here
                                }
                        }
                    }
                }
            } label: {
                Label("Community", systemImage: "rectangle.on.rectangle.angled")
            }
            
            Tab {
                Text("Notifications View")
            } label: {
                Label("Notifications", systemImage: "bell")
            }
            
            Tab {
                Text("Messages View")
            } label: {
                Label("Messages", systemImage: "message")
            }
            
            Tab(role: .search) {
                Text("Search View")
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown) // onScrolUp for chat views, messaging, where latest appears at bottom and scroll up searches back through time

    }
}



#Preview {
    ContentView()
}
