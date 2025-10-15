//
//  DrSarahMartinezConversation.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import Foundation

// MARK: - Dr. Sarah Martinez Conversation
struct DrSarahMartinezConversation {
    static func create() -> (context: ChatContext, messages: [ChatMessage]) {
        let drSara = ChatParticipant(
            id: "sarah_martinez",
            name: "Dr. Sarah Martinez",
            avatarImageIndex: 0, // Match messages tab avatar index
            avatarImageName: nil,
            isOnline: true
        )
        
        let context = ChatContext.dm(participant: drSara)
        
        // Create explicit dates to ensure proper separation
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let messages = [
            // Messages from yesterday (all read - no "New" indicator)
            ChatMessage(
                id: "msg_1",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "Hi Kemi! I've been reviewing your leadership assessment results. The growth in your emotional intelligence scores is truly remarkable - you've improved by 40% since we started working together.",
                timestamp: calendar.date(byAdding: .hour, value: -1, to: yesterday)!, // Yesterday, 1 hour ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Read message
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_2",
                sender: ChatParticipant(
                    id: "kemi_bello",
                    name: "Kemi Bello",
                    avatarImageIndex: nil, // Use static asset via imageName
                    avatarImageName: "Avatar", // Use static asset for current user
                    isOnline: false
                ),
                content: "Thank you so much, Dr. Martinez! That means a lot to me. I've been really focusing on the active listening techniques you taught me, and I can already see the difference in how my team responds.",
                timestamp: calendar.date(byAdding: .minute, value: -5, to: calendar.date(byAdding: .hour, value: -1, to: yesterday)!)!, // Yesterday, 55 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Read message
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_3",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "That's exactly what I was hoping to hear! The way you've been applying the emotional intelligence frameworks in your daily interactions shows real growth. How are you feeling about the upcoming team restructuring?",
                timestamp: calendar.date(byAdding: .minute, value: -10, to: calendar.date(byAdding: .hour, value: -1, to: yesterday)!)!, // Yesterday, 50 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Read message
                mediaAttachments: nil
            ),
            
            // Messages from today - newest unread message will show "New" indicator
            ChatMessage(
                id: "msg_4",
                sender: ChatParticipant(
                    id: "kemi_bello",
                    name: "Kemi Bello",
                    avatarImageIndex: nil, // Use static asset via imageName
                    avatarImageName: "Avatar", // Use static asset for current user
                    isOnline: false
                ),
                content: "I'm actually feeling much more confident about it now. The conflict resolution strategies we practiced have been incredibly helpful. I had a difficult conversation with one of my direct reports yesterday, and it went much better than I expected.",
                timestamp: calendar.date(byAdding: .minute, value: -45, to: today)!, // Today, 45 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Kemi's own message - not unread
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_5",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "That's wonderful progress, Kemi! It sounds like you're really internalizing the coaching principles. Would you like to schedule our next session to discuss the team restructuring in more detail? I have some new frameworks that might be particularly relevant.",
                timestamp: calendar.date(byAdding: .minute, value: -40, to: today)!, // Today, 40 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Unread message
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_6",
                sender: ChatParticipant(
                    id: "kemi_bello",
                    name: "Kemi Bello",
                    avatarImageIndex: nil, // Use static asset via imageName
                    avatarImageName: "Avatar", // Use static asset for current user
                    isOnline: false
                ),
                content: "Yes, absolutely! I'd love to learn more about those frameworks. Would next Tuesday at 2 PM work for you? I'm particularly interested in how to maintain team morale during the transition.",
                timestamp: calendar.date(byAdding: .minute, value: -35, to: today)!, // Today, 35 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Kemi's own message - not unread
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_7",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "Perfect! Tuesday at 2 PM works great. I'll send you some pre-session materials about change management and team dynamics. You're asking exactly the right questions - maintaining morale during transitions is crucial for long-term success.",
                timestamp: calendar.date(byAdding: .minute, value: -30, to: today)!, // Today, 30 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Unread message
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_8",
                sender: ChatParticipant(
                    id: "kemi_bello",
                    name: "Kemi Bello",
                    avatarImageIndex: nil, // Use static asset via imageName
                    avatarImageName: "Avatar", // Use static asset for current user
                    isOnline: false
                ),
                content: "Thank you! I really appreciate all your guidance. I'll review the materials before our session. Looking forward to Tuesday!",
                timestamp: calendar.date(byAdding: .minute, value: -25, to: today)!, // Today, 25 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false, // Kemi's own message - not unread
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_9",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "You're very welcome, Kemi. Remember, leadership is a journey, not a destination. You're doing excellent work, and I'm proud of the progress you've made. See you Tuesday!",
                timestamp: calendar.date(byAdding: .minute, value: -20, to: today)!, // Today, 20 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: true, // this should trigger "New" on divider above this message
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_10",
                sender: ChatParticipant(
                    id: "sarah_martinez",
                    name: "Dr. Sarah Martinez",
                    avatarImageIndex: 0, // Match messages tab avatar index
                    avatarImageName: nil,
                    isOnline: true
                ),
                content: "These are my top 2 favourite photos from the trip",
                timestamp: calendar.date(byAdding: .minute, value: -10, to: today)!, // Today, 10 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: [
                    MediaAttachment(
                        id: "1",
                        type: .image,
                        name: "Trip Photo 1",
                        imageIndex: 0 // Sequential image assignment
                    ),
                    MediaAttachment(
                        id: "2",
                        type: .image,
                        name: "Trip Photo 2",
                        imageIndex: 1 // Sequential image assignment
                    )
                ]
            )
        ]
        
        return (context, messages)
    }
}
