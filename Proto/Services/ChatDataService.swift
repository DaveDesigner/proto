//
//  ChatDataService.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import Foundation

// MARK: - Chat Data Service
class ChatDataService: ObservableObject {
    static let shared = ChatDataService()
    
    private init() {}
    
    // MARK: - Public Interface
    func getConversationData(for messageData: MessageData) -> (context: ChatContext, messages: [ChatMessage]) {
        return MessagesTabData.createConversation(for: messageData)
    }
    
    func getAllMessagePreviews() -> [MessageData] {
        return MessagesTabData.getAllMessagePreviews()
    }
}

