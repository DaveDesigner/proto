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
    @State private var selectedConversation: MessageData?
    private let chatDataService = ChatDataService.shared
    
    private let messageSegments = ["Inbox", "Agents"]
    
    // Get messages from the data service
    private var sampleMessages: [MessageData] {
        chatDataService.getAllMessagePreviews()
    }
    
    private var messagesBlendMode: BlendMode {
        colorScheme == .dark ? .screen : .multiply
    }
    
    // MARK: - Chat Data Generation
    private func createChatData(for messageData: MessageData) -> (context: ChatContext, messages: [ChatMessage]) {
        return chatDataService.getConversationData(for: messageData)
    }
    
    
    // MARK: - Group Chat Initials Helper
    private func groupChatInitials(for messageData: MessageData) -> String {
        let names = messageData.senderName.components(separatedBy: ", ")
        if names.count >= 2 {
            let firstInitial = String(names[0].prefix(1))
            let secondInitial = String(names[1].prefix(1))
            return "\(firstInitial)\(secondInitial)"
        }
        return String(messageData.senderName.prefix(2))
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
                    .standardHorizontalPadding()
                    .padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch messageSegments[selectedSegment] {
                        case "Inbox":
                            // Professional coaching community messages - preview only
                            LazyVStack(spacing: 12) {
                                ForEach(sampleMessages, id: \.id) { messageData in
                                    NavigationLink(destination: {
                                        let chatData = createChatData(for: messageData)
                                        ChatView(
                                            context: chatData.context,
                                            messages: chatData.messages,
                                            onMessageTap: { message in
                                                print("Tapped message: \(message.content)")
                                            },
                                            onParticipantTap: { participant in
                                                print("Tapped participant: \(participant.name)")
                                            }
                                        )
                                    }) {
                                        // Use the Message component with messages tab context to show unread indicators, without Button wrapper
                                        Message(data: messageData, variant: .full, context: .messagesTab, isButton: false)
                                    }
                                    .buttonStyle(PlainButtonStyle())
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
                                .standardHorizontalPadding()
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 8)
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
                    MessagesProfileMenu(
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
