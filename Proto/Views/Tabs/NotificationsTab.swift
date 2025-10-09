//
//  NotificationsTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct NotificationsTab: View {
    @State private var showingManageNotifications = false
    @State private var showingInviteMembers = false
    @State private var selectedSegment = 0
    @Binding var selectedTintColor: Color
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var unsplashService = UnsplashService.shared
    
    private let notificationSegments = ["Inbox", "Mentions", "Threads", "Following", "Archive"]
    
    // Centralized spacing rules
    private let notificationSpacing: CGFloat = 24
    
    // Example notification data
    private var inboxNotifications: [NotificationData] {
        [
            NotificationData(
                type: .like,
                userName: "Caryn Juen",
                userInitials: "CJ",
                action: "has liked your comment in post",
                content: "After Circle App iOS update",
                timestamp: "50 mins ago",
                isNew: true,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 0,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .mention,
                userName: "Caryn Juen",
                userInitials: "CJ",
                action: "wants to connect with you",
                content: nil,
                timestamp: "Yesterday",
                isNew: true,
                hasActions: true,
                actionTitle: "Connect",
                actionSubtitle: nil,
                imageIndex: 1,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .ai,
                userName: "Caryn Juen",
                userInitials: "CP",
                action: "paused conversation",
                content: nil,
                timestamp: "Mar 26",
                isNew: true,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: "with Calvin Parks",
                imageIndex: 2,
                secondImageIndex: 3,
                isGroupAvatar: true,
                isAI: true
            ),
            NotificationData(
                type: .comment,
                userName: "Sarah Wilson",
                userInitials: "SW",
                action: "commented on your post",
                content: "New Design System Updates",
                timestamp: "2 hours ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 4,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .event,
                userName: "Team Calendar",
                userInitials: "TC",
                action: "starts in 30 minutes",
                content: "Team meeting",
                timestamp: "3 hours ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 5,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .live,
                userName: "Alex Chen",
                userInitials: "AC",
                action: "is going live:",
                content: "Product Demo",
                timestamp: "5 hours ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 6,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .poll,
                userName: "Design Team",
                userInitials: "DT",
                action: "created a poll:",
                content: "Which color scheme do you prefer?",
                timestamp: "1 day ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 7,
                secondImageIndex: 8,
                isGroupAvatar: true,
                isAI: false
            ),
            NotificationData(
                type: .post,
                userName: "Maria Garcia",
                userInitials: "MG",
                action: "shared a new post:",
                content: "Weekly Updates",
                timestamp: "2 days ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 9,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .reply,
                userName: "David Kim",
                userInitials: "DK",
                action: "replied to your comment in",
                content: "iOS Development Discussion",
                timestamp: "3 days ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 10,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ),
            NotificationData(
                type: .alert,
                userName: "System",
                userInitials: "SY",
                action: "Your account security settings have been updated",
                content: nil,
                timestamp: "1 week ago",
                isNew: false,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: nil,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            )
        ]
    }
    
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
                    .standardHorizontalPadding()
                    .padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch notificationSegments[selectedSegment] {
                        case "Inbox":
                            // Notifications list
                            LazyVStack(spacing: notificationSpacing) {
                                ForEach(inboxNotifications) { notification in
                                    Notification(data: notification, selectedTintColor: $selectedTintColor)
                                }
                            }
                            .standardHorizontalPadding()
                            .background(Color(.systemBackground))
                        case "Mentions":
                            LazyVStack(spacing: notificationSpacing) {
                                ForEach(inboxNotifications.filter { $0.type == .mention }) { notification in
                                    Notification(data: notification, selectedTintColor: $selectedTintColor)
                                }
                            }
                            .standardHorizontalPadding()
                            .background(Color(.systemBackground))
                        case "Threads":
                            LazyVStack(spacing: notificationSpacing) {
                                ForEach(inboxNotifications.filter { $0.type == .reply || $0.type == .comment }) { notification in
                                    Notification(data: notification, selectedTintColor: $selectedTintColor)
                                }
                            }
                            .standardHorizontalPadding()
                            .background(Color(.systemBackground))
                        case "Following":
                            LazyVStack(spacing: notificationSpacing) {
                                ForEach(inboxNotifications.filter { $0.type == .post || $0.type == .live }) { notification in
                                    Notification(data: notification, selectedTintColor: $selectedTintColor)
                                }
                            }
                            .standardHorizontalPadding()
                            .background(Color(.systemBackground))
                        case "Archive":
                            LazyVStack(spacing: notificationSpacing) {
                                ForEach(inboxNotifications.filter { !$0.isNew }) { notification in
                                    Notification(data: notification, selectedTintColor: $selectedTintColor)
                                }
                            }
                            .standardHorizontalPadding()
                            .background(Color(.systemBackground))
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 8)
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
                            
                            Button(action: { showingInviteMembers = true }) {
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
        .sheet(isPresented: $showingInviteMembers) {
            InviteMembersSheet()
        }
    }
}

#Preview {
    NotificationsTab(selectedTintColor: .constant(Color.blue))
}
