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
    
    // Professional coaching community messages spanning 3 months
    private let sampleMessages: [MessageData] = [
        // Recent messages (last few days)
        MessageData(
            id: "1",
            senderName: "Dr. Sarah Martinez",
            timestamp: "2:15 pm",
            messages: ["Just finished reviewing your leadership assessment. The growth in emotional intelligence scores is remarkable!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: true,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 0,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3600) // 1 hour ago
        ),
        MessageData(
            id: "2",
            senderName: "Michael, Jennifer",
            timestamp: "11:30 am",
            messages: ["We're both struggling with the same delegation challenges. Maybe we could do a peer coaching session?"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [1, 2],
            createdAt: Date().addingTimeInterval(-7200) // 2 hours ago
        ),
        MessageData(
            id: "3",
            senderName: "Coach David Kim",
            timestamp: "9:45 am",
            messages: ["The executive presence workshop materials are ready. Looking forward to seeing everyone tomorrow!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: true,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 3,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-86400) // Yesterday
        ),
        MessageData(
            id: "4",
            senderName: "Lisa, Marcus, Elena",
            timestamp: "4:20 pm",
            messages: ["Our accountability group check-in went really well. Elena's breakthrough on work-life balance was inspiring!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [4, 5, 6],
            createdAt: Date().addingTimeInterval(-172800) // 2 days ago
        ),
        MessageData(
            id: "5",
            senderName: "Dr. Rachel Thompson",
            timestamp: "3:15 pm",
            messages: ["Your 360 feedback results show significant improvement in communication effectiveness. Well done!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: true,
            isOnline: false,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 7,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-259200) // 3 days ago
        ),
        
        // Last week
        MessageData(
            id: "6",
            senderName: "James, Priya",
            timestamp: "1:30 pm",
            messages: ["We completed the conflict resolution simulation. Priya's mediation skills have really developed!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [8, 9],
            createdAt: Date().addingTimeInterval(-604800) // 1 week ago
        ),
        MessageData(
            id: "7",
            senderName: "Coach Amanda Foster",
            timestamp: "10:20 am",
            messages: ["The strategic thinking module is now available. Focus on the decision-making frameworks this week."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 10,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-1209600) // 2 weeks ago
        ),
        MessageData(
            id: "8",
            senderName: "Dr. Kevin Patel",
            timestamp: "2:45 pm",
            messages: ["Your leadership style assessment reveals a strong preference for collaborative decision-making. This aligns well with your team dynamics."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 11,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-1814400) // 3 weeks ago
        ),
        
        // Last month
        MessageData(
            id: "9",
            senderName: "Maria, Carlos, Sophie",
            timestamp: "11:15 am",
            messages: ["Our peer coaching triad has been incredibly valuable. Sophie's insights on cross-cultural leadership were eye-opening."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [12, 13, 14],
            createdAt: Date().addingTimeInterval(-2419200) // 4 weeks ago
        ),
        MessageData(
            id: "10",
            senderName: "Coach Benjamin Wright",
            timestamp: "3:30 pm",
            messages: ["The quarterly review shows excellent progress across all competency areas. Your commitment to growth is evident."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 15,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3024000) // 5 weeks ago
        ),
        MessageData(
            id: "11",
            senderName: "Dr. Angela Chen",
            timestamp: "9:00 am",
            messages: ["The emotional intelligence workshop feedback was overwhelmingly positive. Your vulnerability in sharing challenges inspired many participants."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 16,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3628800) // 6 weeks ago
        ),
        
        // Two months ago
        MessageData(
            id: "12",
            senderName: "Alex, Taylor, Jordan",
            timestamp: "2:00 pm",
            messages: ["Our mastermind group discussion on authentic leadership was transformative. Jordan's perspective on vulnerability in leadership really resonated."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [17, 18, 19],
            createdAt: Date().addingTimeInterval(-7776000) // 9 weeks ago
        ),
        MessageData(
            id: "13",
            senderName: "Coach Michelle Rodriguez",
            timestamp: "4:45 pm",
            messages: ["The advanced communication strategies module is now live. Focus on active listening techniques this month."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 20,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-12096000) // 14 weeks ago
        ),
        
        // Three months ago
        MessageData(
            id: "14",
            senderName: "Dr. Robert Kim",
            timestamp: "1:20 pm",
            messages: ["Welcome to the executive coaching program! Your initial assessment shows strong potential for leadership development."],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 21,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-15552000) // 18 weeks ago
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
                    //.padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch messageSegments[selectedSegment] {
                        case "Inbox":
                            // Professional coaching community messages - preview only
                            LazyVStack(spacing: 0) {
                                ForEach(Array(sampleMessages.enumerated()), id: \.element.id) { index, messageData in
                                    Message(data: messageData, variant: .preview) {
                                        // Handle message tap
                                        print("Tapped message: \(messageData.senderName)")
                                    }
                                    
                                    if index < sampleMessages.count - 1 {
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
