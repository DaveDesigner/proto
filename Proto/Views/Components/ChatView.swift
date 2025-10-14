//
//  ChatView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Chat Context Types
enum ChatContext {
    case dm(participant: ChatParticipant)
    case group(participants: [ChatParticipant])
    case publicSpace(name: String)
}

// MARK: - Chat Participant Model
struct ChatParticipant {
    let id: String
    let name: String
    let headline: String?
    let avatarImageIndex: Int?
    let isOnline: Bool
}

// MARK: - Chat Message Model
struct ChatMessage {
    let id: String
    let sender: ChatParticipant
    let content: String
    let timestamp: Date
    let hasReplies: Bool
    let replyCount: Int
    let replyAvatars: [String]
    let hasNewMessage: Bool
    let mediaAttachments: [MediaAttachment]?
}

// MARK: - Media Attachment Model
struct MediaAttachment {
    let id: String
    let type: MediaType
    let url: String?
    let thumbnailUrl: String?
    let name: String?
}

enum MediaType {
    case image
    case video
    case file
}

// MARK: - Date Divider Model
struct DateDivider {
    let date: Date
    let formattedDate: String
}

// MARK: - Chat View Component
struct ChatView: View {
    let context: ChatContext
    let messages: [ChatMessage]
    let dateDividers: [DateDivider]
    let onMessageTap: ((ChatMessage) -> Void)?
    let onParticipantTap: ((ChatParticipant) -> Void)?
    
    @State private var scrollToBottom = false
    
    init(
        context: ChatContext,
        messages: [ChatMessage] = [],
        dateDividers: [DateDivider] = [],
        onMessageTap: ((ChatMessage) -> Void)? = nil,
        onParticipantTap: ((ChatParticipant) -> Void)? = nil
    ) {
        self.context = context
        self.messages = messages
        self.dateDividers = dateDividers
        self.onMessageTap = onMessageTap
        self.onParticipantTap = onParticipantTap
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Header
            chatHeader
            
            // Messages List
            messagesList
            
            // Message Input Area (placeholder for now)
            messageInputArea
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // MARK: - Chat Header
    private var chatHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Avatar section based on context
                avatarSection
                
                // Title and subtitle section
                titleSection
                
                Spacer()
                
                // Overflow menu button
                Menu {
                    // Context-specific menu items
                    contextMenuItems
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Avatar Section
    private var avatarSection: some View {
        Group {
            switch context {
            case .dm(let participant):
                // Single avatar for DM
                Avatar(
                    initials: participant.name,
                    variant: participant.isOnline ? .online() : .default(),
                    imageIndex: participant.avatarImageIndex
                )
                .onTapGesture {
                    onParticipantTap?(participant)
                }
                
            case .group(let participants):
                // Group avatars (max 3 with overflow indicator)
                groupAvatarStack(participants: participants)
                
            case .publicSpace:
                // No avatar for public spaces
                EmptyView()
            }
        }
        .frame(width: 40, height: 40)
    }
    
    // MARK: - Group Avatar Stack
    private func groupAvatarStack(participants: [ChatParticipant]) -> some View {
        ZStack {
            // Show up to 3 avatars with overlap
            ForEach(Array(participants.prefix(3).enumerated()), id: \.offset) { index, participant in
                Avatar(
                    initials: participant.name,
                    variant: participant.isOnline ? .online() : .default(),
                    imageIndex: participant.avatarImageIndex
                )
                .offset(x: CGFloat(index * 8))
                .zIndex(Double(3 - index))
                .onTapGesture {
                    onParticipantTap?(participant)
                }
            }
            
            // Overflow indicator if more than 3 participants
            if participants.count > 3 {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("+\(participants.count - 3)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    )
                    .offset(x: CGFloat(3 * 8))
                    .zIndex(0)
            }
        }
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(chatTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            if let subtitle = chatSubtitle {
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
    
    // MARK: - Chat Title
    private var chatTitle: String {
        switch context {
        case .dm(let participant):
            return participant.name
        case .group(let participants):
            return participants.map { $0.name }.joined(separator: ", ")
        case .publicSpace(let name):
            return name
        }
    }
    
    // MARK: - Chat Subtitle
    private var chatSubtitle: String? {
        switch context {
        case .dm(let participant):
            return participant.headline
        case .group(let participants):
            return "\(participants.count) members"
        case .publicSpace:
            return "This is the beginning of your conversation"
        }
    }
    
    // MARK: - Context Menu Items
    private var contextMenuItems: some View {
        Group {
            switch context {
            case .dm:
                Button("View Profile") { }
                Button("Call") { }
                Button("Video Call") { }
                Divider()
                Button("Mute Notifications") { }
                Button("Block") { }
                
            case .group:
                Button("View Members") { }
                Button("Group Info") { }
                Divider()
                Button("Mute Notifications") { }
                Button("Leave Group") { }
                
            case .publicSpace:
                Button("Space Info") { }
                Button("View Members") { }
                Divider()
                Button("Mute Notifications") { }
                Button("Leave Space") { }
            }
        }
    }
    
    // MARK: - Messages List
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    // Messages with date dividers
                    ForEach(Array(messagesWithDividers.enumerated()), id: \.element.id) { index, item in
                        if let divider = item as? DateDivider {
                            dateDividerView(divider)
                        } else if let message = item as? ChatMessage {
                            messageView(message)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
                scrollToBottomIfNeeded(proxy: proxy)
            }
        }
    }
    
    // MARK: - Messages with Dividers
    private var messagesWithDividers: [Any] {
        var items: [Any] = []
        
        // Group messages by date and add dividers
        let calendar = Calendar.current
        var currentDate: Date?
        
        for message in messages.sorted(by: { $0.timestamp < $1.timestamp }) {
            let messageDate = calendar.startOfDay(for: message.timestamp)
            
            if currentDate != messageDate {
                currentDate = messageDate
                let divider = DateDivider(
                    date: messageDate,
                    formattedDate: formatDate(messageDate)
                )
                items.append(divider)
            }
            
            items.append(message)
        }
        
        return items
    }
    
    // MARK: - Date Divider View
    private func dateDividerView(_ divider: DateDivider) -> some View {
        HStack {
            Spacer()
            Text(divider.formattedDate)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Message View
    private func messageView(_ message: ChatMessage) -> some View {
        Message(
            data: MessageData(
                id: message.id,
                senderName: message.sender.name,
                timestamp: formatTime(message.timestamp),
                messages: [message.content],
                hasReplies: message.hasReplies,
                replyCount: message.replyCount,
                replyAvatars: message.replyAvatars,
                hasNewMessage: message.hasNewMessage,
                isOnline: message.sender.isOnline,
                isGroupChat: isGroupChat,
                groupAvatars: nil,
                avatarImageIndex: message.sender.avatarImageIndex,
                groupAvatarImageIndices: nil,
                createdAt: message.timestamp
            ),
            variant: .full,
            onTap: {
                onMessageTap?(message)
            }
        )
    }
    
    // MARK: - Is Group Chat
    private var isGroupChat: Bool {
        switch context {
        case .group:
            return true
        case .dm, .publicSpace:
            return false
        }
    }
    
    // MARK: - Message Input Area
    private var messageInputArea: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                // Placeholder for message input
                Text("Message...")
                    .font(.system(size: 17))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Spacer()
                
                // Send button placeholder
                Button(action: {}) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func scrollToBottomIfNeeded(proxy: ScrollViewReader) {
        if scrollToBottom, let lastMessage = messages.last {
            withAnimation(.easeInOut(duration: 0.5)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ChatView(
            context: .dm(participant: ChatParticipant(
                id: "1",
                name: "Mike Walero",
                headline: "Product Designer at Circle",
                avatarImageIndex: 0,
                isOnline: true
            )),
            messages: [
                ChatMessage(
                    id: "1",
                    sender: ChatParticipant(
                        id: "1",
                        name: "Mike Walero",
                        headline: nil,
                        avatarImageIndex: 0,
                        isOnline: true
                    ),
                    content: "Hey team, What's up?",
                    timestamp: Date().addingTimeInterval(-3600),
                    hasReplies: false,
                    replyCount: 0,
                    replyAvatars: [],
                    hasNewMessage: true,
                    mediaAttachments: nil
                ),
                ChatMessage(
                    id: "2",
                    sender: ChatParticipant(
                        id: "2",
                        name: "Sarah Chen",
                        headline: nil,
                        avatarImageIndex: 1,
                        isOnline: true
                    ),
                    content: "Not much, just working on the new features. How about you?",
                    timestamp: Date().addingTimeInterval(-1800),
                    hasReplies: false,
                    replyCount: 0,
                    replyAvatars: [],
                    hasNewMessage: false,
                    mediaAttachments: nil
                )
            ]
        )
    }
}
