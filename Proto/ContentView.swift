//
//  ContentView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Main Content View

struct ContentView: View {
    var body: some View {
        TabView {
            Tab {
                CommunityTab()
            } label: {
                Label("Community", systemImage: "rectangle.on.rectangle.angled")
            }
            
            Tab {
                NotificationsTab()
            } label: {
                Label("Notifications", systemImage: "bell")
            }
            
            Tab {
                MessagesTab()
            } label: {
                Label("Messages", systemImage: "message")
            }
            
            // Remove unsupported role: parameter and use the standard Tab initializer
            Tab {
                SearchTab()
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        //.tabViewSearchActivation(.searchTabSelection)
        .tabBarMinimizeBehavior(.onScrollDown) // onScrolUp for chat views, messaging, where latest appears at bottom and scroll up searches back through time
        .tint(Color(red: 6/255.0, green: 60/255.0, blue: 255/255.0))
    }
}

#Preview {
    ContentView()
}
