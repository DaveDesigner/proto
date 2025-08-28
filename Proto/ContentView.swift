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
                .scrollEdgeEffectHidden()
                .ignoresSafeArea()
                .coordinateSpace(name: "scroll")

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



#Preview {
    ContentView()
}
