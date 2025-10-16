//
//  DefaultConversation.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import Foundation

// MARK: - Default Conversation
struct DefaultConversation {
    static func create(for messageData: MessageData) -> (context: ChatContext, messages: [ChatMessage]) {
        let participant = ChatParticipant(
            id: messageData.id,
            name: messageData.senderName,
            avatarImageIndex: messageData.avatarImageIndex,
            avatarImageName: nil,
            isOnline: messageData.isOnline
        )
        
        let context: ChatContext
        if messageData.isGroupChat {
            // For group chats, create multiple participants
            let names = messageData.senderName.components(separatedBy: ", ")
            let participants = names.enumerated().map { index, name in
                ChatParticipant(
                    id: "\(messageData.id)_\(index)",
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    avatarImageIndex: (messageData.groupAvatarImageIndices?.indices.contains(index) == true) ? messageData.groupAvatarImageIndices?[index] : nil,
                    avatarImageName: nil,
                    isOnline: false
                )
            }
            context = ChatContext.group(participants: participants)
        } else {
            context = ChatContext.dm(participant: participant)
        }
        
        // Create a simple conversation with the preview message
        let messages = [
            ChatMessage(
                id: "msg_1",
                sender: participant,
                content: messageData.messages.first ?? "Hello!",
                timestamp: messageData.createdAt ?? Date(),
                hasReplies: messageData.hasReplies,
                replyCount: messageData.replyCount,
                replyAvatars: messageData.replyAvatars,
                hasNewMessage: messageData.hasNewMessage,
                mediaAttachments: messageData.mediaAttachments
            )
        ]
        
        return (context, messages)
    }
}


