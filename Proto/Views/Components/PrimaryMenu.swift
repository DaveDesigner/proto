//
//  PrimaryMenu.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PrimaryMenu: View {
    // Standard profile actions
    let onProfile: () -> Void
    let onNotifications: () -> Void
    let onSignOut: () -> Void
    
    // Community-specific actions (optional)
    let onSummarize: (() -> Void)?
    let onSort: ((String) -> Void)?
    let currentSort: String?
    let onSwitchCommunity: (() -> Void)?
    
    // Admin settings state
    @State private var showingAdminSettings = false
    @State private var showingSummarize = false
    @State private var showingSwitchCommunity = false
    @State private var showingManageNotifications = false
    
    // Initialize for standard profile menu
    init(
        onProfile: @escaping () -> Void,
        onNotifications: @escaping () -> Void,
        onSignOut: @escaping () -> Void
    ) {
        self.onProfile = onProfile
        self.onNotifications = onNotifications
        self.onSignOut = onSignOut
        self.onSummarize = nil
        self.onSort = nil
        self.currentSort = nil
        self.onSwitchCommunity = nil
    }
    
    // Initialize for community profile menu
    init(
        onProfile: @escaping () -> Void,
        onNotifications: @escaping () -> Void,
        onSignOut: @escaping () -> Void,
        onSummarize: @escaping () -> Void,
        onSort: @escaping (String) -> Void,
        currentSort: String,
        onSwitchCommunity: @escaping () -> Void
    ) {
        self.onProfile = onProfile
        self.onNotifications = onNotifications
        self.onSignOut = onSignOut
        self.onSummarize = onSummarize
        self.onSort = onSort
        self.currentSort = currentSort
        self.onSwitchCommunity = onSwitchCommunity
    }
    
    var body: some View {
        Menu {
            // Community-specific actions (only shown when provided)
            if onSummarize != nil {
                Button(action: { showingSummarize = true }) {
                    HStack {
                        Image(systemName: "sparkle")
                        Text("Summarize")
                    }
                }
                .tint(Color(red: 150/255, green: 118/255, blue: 248/255))

                Divider()
            }
            
            // Sort section (only shown when provided)
            if let onSort = onSort, let currentSort = currentSort {
                Menu {
                    Button(action: { onSort("Latest") }) {
                        HStack {
                            Text("Latest")
                            Spacer()
                            if currentSort == "Latest" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .tint(currentSort == "Latest" ? .secondary : .primary)
                    
                    Button(action: { onSort("Alphabetical") }) {
                        HStack {
                            Text("Alphabetical")
                            Spacer()
                            if currentSort == "Alphabetical" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .tint(currentSort == "Alphabetical" ? .secondary : .primary)
                    
                    Button(action: { onSort("Oldest") }) {
                        HStack {
                            Text("Oldest")
                            Spacer()
                            if currentSort == "Oldest" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .tint(currentSort == "Oldest" ? .secondary : .primary)
                    
                    Button(action: { onSort("Popular") }) {
                        HStack {
                            Text("Popular")
                            Spacer()
                            if currentSort == "Popular" {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .tint(currentSort == "Popular" ? .secondary : .primary)
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                        .labelStyle(.titleAndIcon)
                        .badge(currentSort)
                }
                .tint(.primary)
                
                Divider()
            }
            
            // Standard profile menu items (always shown)
            Button(action: { showingManageNotifications = true }) {
                Label("Manage notifications", systemImage: "bell.badge")
            }
            .tint(.primary)
            
            Button(action: onProfile) {
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
            
            // Switch community (only shown when provided)
            if onSwitchCommunity != nil {
                Button(action: { showingSwitchCommunity = true }) {
                    Label("Switch community", systemImage: "rectangle.on.rectangle.angled")
                }
                .tint(.primary)
            }
            
            Button(action: { showingAdminSettings = true }) {
                Label("Admin settings", systemImage: "gearshape")
            }
            .tint(.primary)
            
            Divider()
            
            Button(role: .destructive) {
                onSignOut()
            }
            label: {
                Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
            }
            .tint(.red)
        } label: {
            Image("Avatar")
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
        }
        .sheet(isPresented: $showingAdminSettings) {
            AdminSettingsSheet()
        }
        .sheet(isPresented: $showingSummarize) {
            SummarizeSheet()
        }
        .sheet(isPresented: $showingSwitchCommunity) {
            SwitchCommunitySheet()
        }
        .sheet(isPresented: $showingManageNotifications) {
            ManageNotificationsSheet()
        }
    }
}

#Preview("Standard Profile Menu") {
    PrimaryMenu(
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSignOut: { print("Sign out tapped") }
    )
}


#Preview("Community Profile Menu") {
    PrimaryMenu(
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSignOut: { print("Sign out tapped") },
        onSummarize: { print("Summarize tapped") },
        onSort: { sort in print("Sort changed to: \(sort)") },
        currentSort: "Latest",
        onSwitchCommunity: { print("Switch community tapped") }
    )
}
