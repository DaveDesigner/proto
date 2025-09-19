//
//  NotificationsTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct NotificationsTab: View {
    @State private var showingManageNotifications = false
    @State private var selectedSegment = 0
    @Binding var selectedTintColor: Color
    @Environment(\.colorScheme) private var colorScheme
    
    private let notificationSegments = ["Inbox", "Mentions", "Threads", "Following", "Archive"]
    
    private var notificationsBlendMode: BlendMode {
        colorScheme == .dark ? .screen : .multiply
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Segment control for content switching
                    SegmentControl(
                        segments: notificationSegments,
                        selectedIndex: $selectedSegment,
                        onSelectionChanged: { index in
                            selectedSegment = index
                        },
                        tintColor: selectedTintColor
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch notificationSegments[selectedSegment] {
                        case "Inbox":
                            // Notifications image scaled to fill width and fully scrollable
                            if let _ = UIImage(named: "Notifications") {
                                Image("Notifications")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .clipped()
                                    .blendMode(notificationsBlendMode)
                            } else {
                                // Fallback if image not found
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .frame(height: 400)
                                    .overlay(
                                        Text("Inbox Notifications")
                                            .font(.headline)
                                    )
                                    .padding(.horizontal)
                            }
                        case "Mentions":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Mentions Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Threads":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Threads Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Following":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Following Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Archive":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Archive Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 16)
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
                    Menu {
                        // Manage notifications
                        Button(action: { showingManageNotifications = true }) {
                            Label("Manage notifications", systemImage: "bell.badge")
                        }
                        .tint(.primary)
                        
                        // Profile
                        Button(action: { /* Add profile action here */ }) {
                            HStack {
                                Image("Avatar")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                Text("Profile")
                            }
                        }
                        .tint(.primary)
                        
                        Divider()
                        
                        // Admin settings submenu
                        Menu {
                            Button(action: {}) {
                                Label("View as", systemImage: "eye")
                            }
                            .tint(.primary)
                            
                            Button(action: {}) {
                                Label("Invite members", systemImage: "person.badge.plus")
                            }
                            .tint(.primary)
                            
                            Button(action: {}) {
                                Label("Manage members", systemImage: "person.2")
                            }
                            .tint(.primary)

                            Divider()
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "sparkle")
                                    Text("Copilot")
                                }
                            }
                            .tint(Color(red: 150/255, green: 118/255, blue: 248/255))
                            
                            Button(action: {}) {
                                Label("AI Inbox", systemImage: "tray")
                            }
                            .tint(.primary)
                            
                            Divider()

                            Button(action: {}) {
                                Label("Push notification", systemImage: "bell")
                            }
                            .tint(.primary)
                            
                            Button(action: {}) {
                                Label("Drafts", systemImage: "doc.text")
                            }
                            .tint(.primary)
                        } label: {
                            Label("Admin settings", systemImage: "gearshape")
                        }
                        .tint(.primary)
                        
                        Divider()
                        
                        // Sign out
                        Button(role: .destructive) {
                            /* Add sign out action here */
                        }
                        label: {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        // Explicitly force red to avoid being overridden by a global .tint
                        .tint(.red)
                    } label: {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    }
                }
                .sharedBackgroundHidden()
            }
        }
        .sheet(isPresented: $showingManageNotifications) {
            ManageNotificationsSheet()
        }
    }
}

#Preview {
    NotificationsTab(selectedTintColor: .constant(Color.blue))
}
