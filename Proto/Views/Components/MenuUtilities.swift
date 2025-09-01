//
//  MenuUtilities.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Shared Menu Content

@ViewBuilder
func profileMenuContent(
    onProfile: @escaping () -> Void,
    onNotifications: @escaping () -> Void,
    onSwitchCommunity: @escaping () -> Void,
    onAdminSettings: @escaping () -> Void,
    onSignOut: @escaping () -> Void
) -> some View {
    // Manage notifications
    Button(action: onNotifications) {
        Label("Manage notifications", systemImage: "bell.badge")
    }
    
    // Profile
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
    
    // Switch community
    Button(action: onSwitchCommunity) {
        Label("Switch community", systemImage: "rectangle.on.rectangle.angled")
    }
    
    // Admin settings
    Button(action: onAdminSettings) {
        Label("Admin settings", systemImage: "gearshape")
    }
    
    Divider()
    
    // Sign out
    Button(role: .destructive) {
        onSignOut()
    } label: {
        Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
    }
}
