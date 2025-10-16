//
//  MichaelJenniferConversation.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import Foundation

// MARK: - Michael & Jennifer Group Conversation
struct MichaelJenniferConversation {
    static func create() -> (context: ChatContext, messages: [ChatMessage]) {
        let michael = ChatParticipant(
            id: "michael_cooper",
            name: "Michael Cooper",
            avatarImageIndex: 1,
            avatarImageName: nil,
            isOnline: false
        )
        
        let jennifer = ChatParticipant(
            id: "jennifer_lee",
            name: "Jennifer Lee",
            avatarImageIndex: 2,
            avatarImageName: nil,
            isOnline: false
        )
        
        let context = ChatContext.group(participants: [michael, jennifer])
        
        let messages = [
            ChatMessage(
                id: "msg_1",
                sender: michael,
                content: "Hey Jennifer, I've been thinking about our delegation challenges. I read this article about the 'delegation ladder' framework - it really resonated with me.",
                timestamp: Date().addingTimeInterval(-7200), // 2 hours ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_2",
                sender: jennifer,
                content: "That sounds interesting! I've been struggling with the same thing. What's the delegation ladder about?",
                timestamp: Date().addingTimeInterval(-6900), // 1 hour 55 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_3",
                sender: michael,
                content: "It's a framework that helps you gradually increase team autonomy. You start by telling them exactly what to do, then move to showing them, then to guiding them, and finally to delegating completely. I think I've been jumping too quickly to full delegation.",
                timestamp: Date().addingTimeInterval(-6600), // 1 hour 50 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_4",
                sender: jennifer,
                content: "That makes so much sense! I think I've been doing the opposite - I delegate too much too soon, then get frustrated when things don't go as expected. Maybe we could do a peer coaching session on this?",
                timestamp: Date().addingTimeInterval(-6300), // 1 hour 45 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_5",
                sender: michael,
                content: "Absolutely! I'd love that. We could share our experiences and maybe role-play some scenarios. What do you think about meeting next week?",
                timestamp: Date().addingTimeInterval(-6000), // 1 hour 40 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_6",
                sender: jennifer,
                content: "Perfect! How about Tuesday at 3 PM? I can share some of the delegation challenges I'm facing with my new team members.",
                timestamp: Date().addingTimeInterval(-5700), // 1 hour 35 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_7",
                sender: michael,
                content: "Tuesday at 3 PM works great for me. I'll bring some examples of where I think I went wrong with delegation, and we can work through them together.",
                timestamp: Date().addingTimeInterval(-5400), // 1 hour 30 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_8",
                sender: jennifer,
                content: "Sounds like a plan! I'm really looking forward to this. It's so helpful to have someone who understands the challenges of management.",
                timestamp: Date().addingTimeInterval(-5100), // 1 hour 25 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            ),
            ChatMessage(
                id: "msg_9",
                sender: michael,
                content: "Me too! See you Tuesday. Thanks for being open to this - I think we'll both learn a lot.",
                timestamp: Date().addingTimeInterval(-4800), // 1 hour 20 minutes ago
                hasReplies: false,
                replyCount: 0,
                replyAvatars: [],
                hasNewMessage: false,
                mediaAttachments: nil
            )
        ]
        
        return (context, messages)
    }
}


