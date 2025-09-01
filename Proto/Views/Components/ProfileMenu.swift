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
    let onSignOut: () -> Void
    
    var body: some View {
        PrimaryMenu(
            onProfile: onProfile,
            onNotifications: onNotifications,
            onSignOut: onSignOut
        )
    }
}

#Preview {
    ProfileMenu(
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSignOut: { print("Sign out tapped") }
    )
}
