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
    let avatarImageIndex: Int? // Index for Unsplash image, nil for initials
    let groupAvatarImageIndices: [Int]? // Indices for group chat Unsplash images
    let createdAt: Date? // For relative date formatting
}

// MARK: - Message Variants
enum MessageVariant {
    case full // Full message with all details
    case preview // Compact preview for inline chats
}

// MARK: - Message Component
struct Message: View {
    let data: MessageData
    let variant: MessageVariant
    let onTap: (() -> Void)?
    
    init(data: MessageData, variant: MessageVariant = .full, onTap: (() -> Void)? = nil) {
        self.data = data
        self.variant = variant
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(alignment: .top, spacing: 12) {
                // Avatar section
                avatarSection
                
                // Content section
                contentSection
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 0)
            .padding(.bottom, 12)
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        ZStack {
            if data.isGroupChat, let groupImageIndices = data.groupAvatarImageIndices, groupImageIndices.count >= 2 {
                // Group chat with two avatars using Unsplash
                Avatar(
                    initials: groupChatInitials,
                    variant: .group(),
                    imageIndex: groupImageIndices[0], // Use first image index for first avatar
                    secondImageIndex: groupImageIndices[1] // Use second image index for second avatar
                )
            } else {
                // Single avatar with Unsplash or initials
                let variant: AvatarVariant = data.isOnline ? .online() : .default()
                Avatar(
                    initials: data.senderName,
                    variant: variant,
                    imageIndex: data.avatarImageIndex
                )
            }
        }
        .frame(width: 40, height: 40)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Name row with timestamp and new message indicator
            nameRow
            
            // Message content - varies by variant
            if variant == .preview {
                previewMessageContent
            } else {
                messageContent
                
                // Replies section - only in full variant
                if data.hasReplies {
                    repliesSection
                }
            }
        }
    }
    
    // MARK: - Name Row
    private var nameRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            // Name and timestamp with proper spacing
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(displayName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                RelativeDate(date: data.createdAt ?? Date(), variant: .messages, foregroundColor: Color.tertiary)
            }
            
            Spacer(minLength: 0)
            
            // New message indicator - only in full variant
            if variant == .full && data.hasNewMessage {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    // MARK: - Display Name
    private var displayName: String {
        if data.isGroupChat {
            // For group chats, show member names with truncation
            return data.senderName
        } else {
            return data.senderName
        }
    }
    
    // MARK: - Group Chat Initials Logic
    private var groupChatInitials: String {
        guard data.isGroupChat else { return data.senderName }
        
        // Extract initials from group chat names
        let names = data.senderName.components(separatedBy: ", ")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        if names.count >= 2 {
            // For group chats, use first letter of first two names
            let firstInitial = extractFirstLetter(from: names[0])
            let secondInitial = extractFirstLetter(from: names[1])
            return (firstInitial + secondInitial).uppercased()
        } else if names.count == 1 {
            // Single name in group chat
            let firstLetter = extractFirstLetter(from: names[0])
            return firstLetter.uppercased()
        }
        
        return data.senderName
    }
    
    // Helper function to extract the first letter from a name
    private func extractFirstLetter(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        
        // Handle names that start with non-letter characters
        if trimmed.first?.isLetter == false {
            return String(trimmed.prefix(1))
        }
        
        // Find the first letter
        for char in trimmed {
            if char.isLetter {
                return String(char)
            }
        }
        
        // Fallback to first character
        return String(trimmed.prefix(1))
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
    
    // MARK: - Preview Message Content
    private var previewMessageContent: some View {
        Text(previewText)
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.primary)
            .lineLimit(1)
            .truncationMode(.tail)
    }
    
    // MARK: - Preview Text
    private var previewText: String {
        // For preview, show only the first message, truncated
        let message = data.messages.first ?? ""
        
        // For group chats, we might want to show a different preview format
        if data.isGroupChat {
            return message
        }
        
        return message
    }
    
    // MARK: - Replies Section
    private var repliesSection: some View {
        HStack(spacing: 8) {
            // Facepile for reply avatars
            HStack(spacing: -4) {
                ForEach(Array(data.replyAvatars.prefix(3).enumerated()), id: \.offset) { index, _ in
                    Avatar(
                        initials: "R\(index + 1)", // Reply initials
                        variant: .size24,
                        imageIndex: index + 10 // Use different Unsplash images for replies
                    )
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
        // Full variant examples
        Text("Full Variant")
            .font(.headline)
            .padding()
        
        // Single message, no replies, no reactions - with Unsplash image
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
            groupAvatars: nil,
            avatarImageIndex: 0,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3600) // 1 hour ago
        ))
        
        Divider()
        
        // Multiple messages, with replies, no reactions - with Unsplash image
        Message(data: MessageData(
            id: "3",
            senderName: "Alex Johnson",
            timestamp: "3:11 pm",
            messages: [
                "Hey team, Whats up?",
                "Hope everybody had a great weekend!!"
            ],
            hasReplies: true,
            replyCount: 3,
            replyAvatars: ["R1", "R2", "R3"],
            hasNewMessage: true,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 1,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-7200) // 2 hours ago
        ))
        
        Divider()
        
        // Preview variant examples
        Text("Preview Variant")
            .font(.headline)
            .padding()
        
        // Preview - recent message
        Message(data: MessageData(
            id: "5",
            senderName: "Sarah Chen",
            timestamp: "2:45 pm",
            messages: ["Thanks for the update! Looking forward to the next iteration"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 2,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-86400) // Yesterday
        ), variant: .preview)
        
        Divider()
        
        // Preview - group chat
        Message(data: MessageData(
            id: "6",
            senderName: "Design Team",
            timestamp: "1:30 pm",
            messages: ["Let's discuss the new features for next sprint"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: false,
            isGroupChat: true,
            groupAvatars: nil,
            avatarImageIndex: nil,
            groupAvatarImageIndices: [3, 4],
            createdAt: Date().addingTimeInterval(-172800) // 2 days ago
        ), variant: .preview)
        
        Divider()
        
        // Preview - older message
        Message(data: MessageData(
            id: "7",
            senderName: "Emma Wilson",
            timestamp: "11:30 am",
            messages: ["Can we schedule a meeting for tomorrow?"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 5,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-604800) // 1 week ago
        ), variant: .preview)
    }
    .background(Color(.systemBackground))
}
