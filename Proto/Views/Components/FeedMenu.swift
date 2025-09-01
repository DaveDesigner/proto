//
//  FeedMenu.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct FeedMenu: View {
    let onSummarize: () -> Void
    let onSort: (String) -> Void
    let currentSort: String
    let onProfile: () -> Void
    let onNotifications: () -> Void
    let onSwitchCommunity: () -> Void
    let onAdminSettings: () -> Void
    let onSignOut: () -> Void
    
    var body: some View {
        Menu {
            // Community-specific actions at the top
            Button(action: onSummarize) {
                Label("Summarize", systemImage: "sparkle")
            }
            
            Divider()
            
            // Sort section with submenu
            Menu {
                Button(action: { onSort("Latest") }) {
                    HStack {
                        Text("Latest")
                        Spacer()
                        if currentSort == "Latest" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Button(action: { onSort("Alphabetical") }) {
                    HStack {
                        Text("Alphabetical")
                        Spacer()
                        if currentSort == "Alphabetical" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Button(action: { onSort("Oldest") }) {
                    HStack {
                        Text("Oldest")
                        Spacer()
                        if currentSort == "Oldest" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Button(action: { onSort("Popular") }) {
                    HStack {
                        Text("Popular")
                        Spacer()
                        if currentSort == "Popular" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
                    .labelStyle(.titleAndIcon)
                    .badge(currentSort)
            }
            
            Divider()
            
            // Use shared profile menu content
            profileMenuContent(
                onProfile: onProfile,
                onNotifications: onNotifications,
                onSwitchCommunity: onSwitchCommunity,
                onAdminSettings: onAdminSettings,
                onSignOut: onSignOut
            )
        } label: {
            Image("Avatar")
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
        }
    }
}

#Preview {
    FeedMenu(
        onSummarize: { print("Summarize tapped") },
        onSort: { sort in print("Sort changed to: \(sort)") },
        currentSort: "Latest",
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSwitchCommunity: { print("Switch community tapped") },
        onAdminSettings: { print("Admin settings tapped") },
        onSignOut: { print("Sign out tapped") }
    )
}
