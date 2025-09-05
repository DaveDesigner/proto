//
//  ContentView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    @State private var selectedTintColor = Color(red: 6/255.0, green: 60/255.0, blue: 255/255.0)
    
    var body: some View {
        TabView {
            Tab {
                CommunityTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label("Community", systemImage: "rectangle.on.rectangle.angled")
            }
            
            Tab {
                NotificationsTab()
            } label: {
                Label("Notifications", systemImage: "bell")
            }
            
            Tab {
                MessagesTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label("Messages", systemImage: "message")
            }
            
            Tab(role: .search) {
                SearchTab(selectedTintColor: $selectedTintColor)
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        //.tabViewSearchActivation(.searchTabSelection)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(selectedTintColor)
    }
}

#Preview {
    ContentView()
}
