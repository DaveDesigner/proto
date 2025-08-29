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
                .scrollEdgeEffectHidden(false)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem() {
                        Button(action: {
                            // Add new item action here
                        }) {
                            Image(systemName: "plus")
                                .font(.title3)
                        }
                    }
                    ToolbarSpacer()
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            // Add user profile action here
                        }) {
                            Image("Avatar")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        .padding(0)
                    }
                }
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



#Preview {
    ContentView()
}
