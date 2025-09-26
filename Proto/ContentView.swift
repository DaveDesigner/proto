//
//  ContentView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    @State private var selectedTintColor = Color.primary // Use primary color directly
    @State private var selectedTab = 0
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        TabView {
            Tab {
                CommunityTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label("Community", systemImage: "rectangle.on.rectangle.angled")
            }
            
            Tab {
                NotificationsTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label("Notifications", systemImage: "bell")
            }
            
            Tab {
                MessagesTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label {
                    Text("Messages")
                } icon: {
                    Image("Messages24")
                }
            }
            
            Tab(role: .search) {
                SearchTab(selectedTintColor: $selectedTintColor)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(selectedTintColor)
    }
}

#Preview {
    ContentView()
}
