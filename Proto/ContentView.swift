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
                            Menu {
                                // Summarize section
                                Button(action: {
                                    // Add summarize action here
                                }) {
                                    Label("Summarize", systemImage: "sparkles")
                                }
                                
                                Divider()
                                
                                // Sort section with submenu
                                Menu {
                                    Button(action: {
                                        // Latest action
                                    }) {
                                        Label("Latest", systemImage: "arrow.up.arrow.down")
                                    }
                                    
                                    Button(action: {
                                        // Alphabetical action
                                    }) {
                                        Label("Alphabetical", systemImage: "textformat.abc")
                                    }
                                    
                                    Button(action: {
                                        // Oldest action
                                    }) {
                                        Label("Oldest", systemImage: "clock")
                                    }
                                    
                                    Button(action: {
                                        // Popular action
                                    }) {
                                        Label("Popular", systemImage: "star")
                                    }
                                } label: {
                                    Label("Sort", systemImage: "arrow.up.arrow.down")
                                }
                                
                                Divider()
                                
                                // Manage notifications
                                Button(action: {
                                    // Add notifications action here
                                }) {
                                    Label("Manage notifications", systemImage: "bell.badge")
                                }
                                
                                // Profile
                                Button(action: {
                                    // Add profile action here
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 20, height: 20)
                                            .background(
                                                Image("Avatar")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipShape(Circle())
                                            )
                                        Text("Profile")
                                    }
                                }
                                
                                Divider()
                                
                                // Switch community
                                Button(action: {
                                    // Add switch community action here
                                }) {
                                    Label("Switch community", systemImage: "rectangle.on.rectangle.angled")
                                }
                                
                                // Admin settings
                                Button(action: {
                                    // Add admin settings action here
                                }) {
                                    Label("Admin settings", systemImage: "gearshape")
                                }
                                
                                Divider()
                                
                                // Sign out
                                Button(action: {
                                    // Add sign out action here
                                }) {
                                    Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            } label: {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Image("Avatar")
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                    )
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
