//
//  NotificationsTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct NotificationsTab: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Notifications View")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .navigationBarTitle("Notifications")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        // Clear all unread notifications action
                    }) {
                        Image(systemName: "checkmark")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarSpacer()

                ToolbarItem(placement: .navigationBarTrailing) {
                    ProfileMenu(
                        onProfile: { /* Add profile action here */ },
                        onNotifications: { /* Add notifications action here */ },
                        onSwitchCommunity: { /* Add switch community action here */ },
                        onAdminSettings: { /* Add admin settings action here */ },
                        onSignOut: { /* Add sign out action here */ }
                    )
                }
            }
        }
    }
}

#Preview {
    NotificationsTab()
}
