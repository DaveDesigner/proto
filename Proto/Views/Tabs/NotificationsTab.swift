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
    
    private let notificationSegments = ["Inbox", "Mentions", "Threads", "Following", "Archive"]
    
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
                        }
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
                        
                        Divider()
                        
                        // Admin settings submenu
                        Menu {
                            Button(action: {}) {
                                Label("View as", systemImage: "eye")
                            }
                            
                            Button(action: {}) {
                                Label("Invite members", systemImage: "person.badge.plus")
                            }
                            
                            Button(action: {}) {
                                Label("Manage members", systemImage: "person.2")
                            }

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
                            
                            Divider()

                            Button(action: {}) {
                                Label("Push notification", systemImage: "bell")
                            }
                            
                            Button(action: {}) {
                                Label("Drafts", systemImage: "doc.text")
                            }
                        } label: {
                            Label("Admin settings", systemImage: "gearshape")
                        }
                        
                        Divider()
                        
                        // Sign out
                        Button(role: .destructive) {
                            /* Add sign out action here */
                        } label: {
                            Label("Sign out", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .sheet(isPresented: $showingManageNotifications) {
            ManageNotificationsSheet()
        }
    }
}

#Preview {
    NotificationsTab()
}
