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
        .onAppear {
            configureTabBarAppearance()
        }
    }
    
    private func configureTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // Set the same color for selected and unselected items
            let itemAppearance = UITabBarItemAppearance()
            let itemColor = UIColor(Color.primary) // Use primary color for both states
            
            itemAppearance.normal.iconColor = itemColor
            itemAppearance.selected.iconColor = itemColor
            itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: itemColor]
            itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: itemColor]
            
            // Apply the item appearance to all layout styles
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            // Assign the customized appearance to the tab bar
            UITabBar.appearance().standardAppearance = appearance
            
            // For iOS 15 and later, also set the scrollEdgeAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        } else {
            // Fallback for earlier iOS versions
            UITabBar.appearance().tintColor = UIColor(Color.primary)
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.primary)
        }
    }
}

#Preview {
    ContentView()
}
