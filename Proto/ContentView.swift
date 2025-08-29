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
                        VStack() {
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
                       // .padding(.top, 16)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Text("Community")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                        }
                        
                        ToolbarItem() {
                            Menu {
                                Button(action: {
                                    // Create a post action
                                }) {
                                    Text("Create a post")
                                }
                                
                                Button(action: {
                                    // Create an image action
                                }) {
                                    Text("Create an image")
                                }
                                
                                Button(action: {
                                    // Go live action
                                }) {
                                    Text("Go live")
                                }
                                
                                Divider()
                                
                                Button(action: {
                                    // Drafts action
                                }) {
                                    Text("Drafts")
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                        }
                        ToolbarSpacer()

                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                // Summarize section
                                Button(action: {
                                    // Add summarize action here
                                }) {
                                    Label("Summarize", systemImage: "sparkle")
                                }
                                
                                Divider()
                                
                                // Sort section with submenu
                                Menu {
                                    Button(action: {
                                        // Latest action
                                    }) {
                                        HStack {
                                            Text("Latest")
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    
                                    Button(action: {
                                        // Alphabetical action
                                    }) {
                                        HStack {
                                            Text("Alphabetical")
                                            Spacer()
                                        }
                                    }
                                    
                                    Button(action: {
                                        // Oldest action
                                    }) {
                                        HStack {
                                            Text("Oldest")
                                            Spacer()
                                        }
                                    }
                                    
                                    Button(action: {
                                        // Popular action
                                    }) {
                                        HStack {
                                            Text("Popular")
                                            Spacer()
                                        }
                                    }
                                } label: {
                                    Label("Sort", systemImage: "arrow.up.arrow.down")
                                        .labelStyle(.titleAndIcon)
                                        .badge("Latest")
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
                                        Image("Avatar")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
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
                                Image("Avatar")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())
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
