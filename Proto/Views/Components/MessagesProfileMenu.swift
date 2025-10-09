//
//  MessagesProfileMenu.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessagesProfileMenu: View {
    let onProfile: () -> Void
    let onNotifications: () -> Void
    let onSignOut: () -> Void
    @Binding var selectedTintColor: Color
    
    // Sheet states
    @State private var showingInviteMembers = false
    @State private var showingManageNotifications = false
    
    var body: some View {
        Menu {
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
            
            // Invite members (replaces admin settings)
            Button(action: { showingInviteMembers = true }) {
                Label("Invite members", systemImage: "person.badge.plus")
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
                .frame(width: 44, height: 44)
                .clipShape(Circle())
        }
        .sheet(isPresented: $showingInviteMembers) {
            InviteMembersSheet()
        }
        .sheet(isPresented: $showingManageNotifications) {
            ManageNotificationsSheet()
        }
    }
}

#Preview {
    MessagesProfileMenu(
        onProfile: { print("Profile tapped") },
        onNotifications: { print("Notifications tapped") },
        onSignOut: { print("Sign out tapped") },
        selectedTintColor: .constant(Color.blue)
    )
}
