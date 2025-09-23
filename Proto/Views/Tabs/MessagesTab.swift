//
//  MessagesTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessagesTab: View {
    @State private var selectedSegment = 0
    @Binding var selectedTintColor: Color
    @Environment(\.colorScheme) private var colorScheme
    
    private let messageSegments = ["Inbox", "Agents"]
    
    // Sample data for demonstration
    private let sampleMessages: [MessageData] = [
        MessageData(
            id: "1",
            senderName: "Mike Walero",
            timestamp: "3:11 pm",
            messages: ["Hey team, Whats up?"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: true,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil
        ),
        MessageData(
            id: "2",
            senderName: "Sarah Chen",
            timestamp: "2:45 pm",
            messages: [
                "Thanks for the update!",
                "Looking forward to the next iteration"
            ],
            hasReplies: true,
            replyCount: 3,
            replyAvatars: ["Avatar", "Avatar", "Avatar"],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: false,
            groupAvatars: nil
        ),
        MessageData(
            id: "3",
            senderName: "Design Team",
            timestamp: "1:30 pm",
            messages: ["Let's discuss the new features for next sprint"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: true,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: ["Avatar", "Avatar"]
        ),
        MessageData(
            id: "4",
            senderName: "Alex Johnson",
            timestamp: "12:15 pm",
            messages: ["The prototype looks great!"],
            hasReplies: true,
            replyCount: 1,
            replyAvatars: ["Avatar"],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil
        )
    ]
    
    private var messagesBlendMode: BlendMode {
        colorScheme == .dark ? .screen : .multiply
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Segment control for content switching
                    SegmentControl(
                        segments: messageSegments,
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
                        switch messageSegments[selectedSegment] {
                        case "Inbox":
                            // Messages list
                            LazyVStack(spacing: 0) {
                                ForEach(sampleMessages, id: \.id) { messageData in
                                    Message(data: messageData) {
                                        // Handle message tap
                                        print("Tapped message: \(messageData.senderName)")
                                    }
                                    
                                    if messageData.id != sampleMessages.last?.id {
                                        Divider()
                                            .padding(.leading, 72) // Align with message content
                                    }
                                }
                            }
                        case "Agents":
                            // Agents content placeholder
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Agents Content")
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
            .navigationBarTitle("Messages")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        // Create new message action
                    }) {
                        Image(systemName: "plus")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarSpacer()

                ToolbarItem(placement: .navigationBarTrailing) {
                    ProfileMenu(
                        onProfile: { /* Add profile action here */ },
                        onNotifications: { /* Add notifications action here */ },
                        onSignOut: { /* Add sign out action here */ },
                        selectedTintColor: $selectedTintColor
                    )
                }
                .sharedBackgroundHidden()
            }
        }
    }
}

#Preview {
    MessagesTab(selectedTintColor: .constant(Color.blue))
}
