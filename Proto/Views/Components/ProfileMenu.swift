//
//  ProfileMenu.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct ProfileMenu: View {
    let onProfile: () -> Void
    let onNotifications: () -> Void
    let onSwitchCommunity: () -> Void
    let onAdminSettings: () -> Void
    let onSignOut: () -> Void
    
    var body: some View {
        Menu {
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
    ProfileMenu(
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSwitchCommunity: { print("Switch community tapped") },
        onAdminSettings: { print("Admin settings tapped") },
        onSignOut: { print("Sign out tapped") }
    )
}
