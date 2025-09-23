//
//  Message.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Message Model
struct MessageData {
    let id: String
    let senderName: String
    let timestamp: String
    let messages: [String]
    let hasReplies: Bool
    let replyCount: Int
    let replyAvatars: [String] // Image names for reply avatars
    let hasNewMessage: Bool
    let isOnline: Bool
    let isGroupChat: Bool
    let groupAvatars: [String]? // For group chats, up to 2 avatars
}

// MARK: - Message Component
struct Message: View {
    let data: MessageData
    let onTap: (() -> Void)?
    
    init(data: MessageData, onTap: (() -> Void)? = nil) {
        self.data = data
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 12) {
                // Avatar section
                avatarSection
                
                // Content section
                contentSection
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        ZStack {
            if data.isGroupChat, let groupAvatars = data.groupAvatars, groupAvatars.count >= 2 {
                // Group chat with two avatars
                HStack(spacing: -4) {
                    Avatar(imageName: groupAvatars[0], size: 24)
                        .zIndex(2)
                    Avatar(imageName: groupAvatars[1], size: 24)
                        .zIndex(1)
                }
                .frame(width: 40, height: 40)
            } else {
                // Single avatar
                Avatar(imageName: "Avatar", size: 40)
                    .overlay(
                        // Online status indicator
                        Group {
                            if data.isOnline {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 14, y: 14)
                            }
                        }
                    )
            }
        }
        .frame(width: 40, height: 40)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name row with timestamp and new message indicator
            nameRow
            
            // Message content
            messageContent
            
            // Replies section
            if data.hasReplies {
                repliesSection
            }
        }
    }
    
    // MARK: - Name Row
    private var nameRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            // Name and timestamp
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(data.senderName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(data.timestamp)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer(minLength: 0)
            
            // New message indicator
            if data.hasNewMessage {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    // MARK: - Message Content
    private var messageContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(data.messages.enumerated()), id: \.offset) { index, message in
                Text(message)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    // MARK: - Replies Section
    private var repliesSection: some View {
        HStack(spacing: 8) {
            // Facepile for reply avatars
            HStack(spacing: -4) {
                ForEach(Array(data.replyAvatars.prefix(3).enumerated()), id: \.offset) { index, avatarName in
                    Avatar(imageName: avatarName, size: 24)
                        .zIndex(Double(3 - index))
                }
            }
            
            Text("\(data.replyCount) replies")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 0) {
        // Single message, no replies, no reactions
        Message(data: MessageData(
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
        ))
        
        Divider()
        
        // Multiple messages, no replies, no reactions
        Message(data: MessageData(
            id: "2",
            senderName: "Mike Walero",
            timestamp: "3:11 pm",
            messages: [
                "Hey team, Whats up?",
                "Hope everybody had a great weekend!!"
            ],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil
        ))
        
        Divider()
        
        // Multiple messages, with replies, no reactions
        Message(data: MessageData(
            id: "3",
            senderName: "Mike Walero",
            timestamp: "3:11 pm",
            messages: [
                "Hey team, Whats up?",
                "Hope everybody had a great weekend!!"
            ],
            hasReplies: true,
            replyCount: 3,
            replyAvatars: ["Avatar", "Avatar", "Avatar"],
            hasNewMessage: true,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil
        ))
        
        Divider()
        
        // Group chat example
        Message(data: MessageData(
            id: "4",
            senderName: "Design Team",
            timestamp: "2:45 pm",
            messages: ["Let's discuss the new features"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: ["Avatar", "Avatar"]
        ))
    }
    .background(Color(.systemBackground))
}
