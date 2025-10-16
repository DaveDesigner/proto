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
struct ChatParticipant: Hashable {
    let id: String
    let name: String
    let avatarImageIndex: Int?
    let avatarImageName: String? // For static assets
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
    let name: String?
    let imageIndex: Int? // For sequential image assignment with UnsplashService
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
    let hasNewMessage: Bool
}

// MARK: - New Message Indicator Model
struct NewMessageIndicator {
    let id = UUID().uuidString
}



// MARK: - Chat View Component
struct ChatView: View {
    let context: ChatContext
    let messages: [ChatMessage]
    let dateDividers: [DateDivider]
    let onMessageTap: ((ChatMessage) -> Void)?
    let onParticipantTap: ((ChatParticipant) -> Void)?
    
    @State private var messageText = AttributedString("")
    @State private var messageSelection: TextSelection?
    @FocusState private var isMessageFocused: Bool
    @State private var isTabBarVisible = false
    @State private var hasUserToggled = false
    @State private var selectedRange: Range<AttributedString.Index>?
    @State private var showMessageMode = false
    @State private var shouldMaintainFocus = false

    // Avatar caching
    @ObservedObject private var unsplashService = UnsplashService.shared
    @State private var cachedAvatars: [String: Image] = [:]

    // Computed property to check if text is selected
    private var hasTextSelection: Bool {
        // TODO: Implement proper text selection monitoring
        // TextSelection works with String-based TextEditor, but we're using AttributedString
        // For now, always return false until we implement UITextView bridge or find SwiftUI solution
        return false
    }

    // Computed property to help with toolbar updates
    private var toolbarState: String {
        "\(showMessageMode)-\(messageText.characters.isEmpty)-\(isMessageFocused)-\(hasTextSelection)"
    }
    
    // Preload avatar images for all participants
    private func preloadAvatars() {
        // Get unique participants from messages
        let participants = Set(messages.map { $0.sender })
        
        for participant in participants {
            if let imageIndex = participant.avatarImageIndex,
               let photo = unsplashService.getPhoto(at: imageIndex) {
                // Cache the avatar image
                let cacheKey = "\(participant.id)_\(imageIndex)"
                if cachedAvatars[cacheKey] == nil {
                    // Load the image asynchronously and cache it
                    Task {
                        if let url = URL(string: photo.urls.small),
                           let (data, _) = try? await URLSession.shared.data(from: url),
                           let uiImage = UIImage(data: data) {
                            let image = Image(uiImage: uiImage)
                            await MainActor.run {
                                cachedAvatars[cacheKey] = image
                            }
                        }
                    }
                }
            }
        }
    }
    
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
        VStack {
            
            messagesList
        }
            .onTapGesture {
                // Dismiss message mode when tapping outside
                if showMessageMode {
                    showMessageMode = false
                    isMessageFocused = false
                    shouldMaintainFocus = false
                    // Return to default state - hide tab bar (toolbar will show automatically)
                    isTabBarVisible = false
                }
            }
            .onAppear {
                // Only reset to default state if user hasn't manually toggled
                if !hasUserToggled {
                    isTabBarVisible = false
                }
                // Preload avatar images for all participants
                preloadAvatars()
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { _ in
                        // Immediately return to default state when scrolling starts
                        // This also resets the user toggle flag so onAppear will work correctly next time
                        hasUserToggled = false
                        isTabBarVisible = false
                        showMessageMode = false
                        // Return to default state (toolbar will show automatically when tab bar is hidden)
                        
                        // Also dismiss keyboard and reset message mode when scrolling
                        if isMessageFocused {
                            isMessageFocused = false
                            showMessageMode = false
                            shouldMaintainFocus = false
                        }
                    }
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text(chatTitle)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if let subtitle = chatSubtitle {
                            Text(subtitle)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        contextMenuItems
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                if showMessageMode {
                    // Show MessageComposer when in message mode
                    ToolbarItemGroup(placement: .bottomBar) {
                        // Conditional menu button - formatting menu when text is selected, full menu otherwise
                        if hasTextSelection {
                            MessageComposerFormattingMenu(text: $messageText, selectedRange: $selectedRange)
                        } else {
                            MessageComposerFormatMenu(text: $messageText, selectedRange: $selectedRange)
                        }

                        Spacer()

                        // MessageComposer input field
                        MessageComposer(
                            text: $messageText,
                            selection: $messageSelection,
                            isFocused: $isMessageFocused,
                            placeholder: "Add message",
                            onSubmit: {
                                // Submit message
                                messageText = AttributedString("")
                                messageSelection = nil
                                isMessageFocused = false
                                showMessageMode = false
                                shouldMaintainFocus = false
                            },
                            onDragStart: {
                                // Handle drag start on message composer - return to default state
                                hasUserToggled = false
                                isTabBarVisible = false
                                showMessageMode = false
                                isMessageFocused = false
                                shouldMaintainFocus = false
                                // Return to default state (toolbar will show automatically when tab bar is hidden)
                            }
                        )
                    }
                } else if !isTabBarVisible {
                    // Show toolbar when not in message mode and tab bar is not visible
                    ToolbarItemGroup(placement: .bottomBar) {
                        // Tabbar toggle button
                        Button(action: {
                            // Mark that user has manually toggled
                            hasUserToggled = true
                            // Toggle tab bar visibility
                            isTabBarVisible.toggle()
                            // Toolbar visibility is now controlled by the SwiftUI toolbar modifier
                        }) {
                            Image("Messages24")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        // Fake text field
                        Text(messageText.characters.isEmpty ? "Add message" : String(messageText.characters.prefix(50)) + (messageText.characters.count > 50 ? "..." : ""))
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                            .background(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                shouldMaintainFocus = true
                                showMessageMode = true
                                // Immediately focus the text field when entering message mode
                                DispatchQueue.main.async {
                                    isMessageFocused = true
                                }
                            }
                    }
                }
            }
            .toolbar(isTabBarVisible ? .visible : .hidden, for: .tabBar)
            .animation(.easeInOut(duration: 0.3), value: isTabBarVisible)
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
        return nil
    }
    
    // MARK: - Context Menu Items
    private var contextMenuItems: some View {
        Group {
            switch context {
            case .dm:
                Button(action: { /* View Profile */ }) {
                    Label("View Profile", systemImage: "person.circle")
                }
                Button(action: { /* Call */ }) {
                    Label("Call", systemImage: "phone")
                }
                Button(action: { /* Video Call */ }) {
                    Label("Video Call", systemImage: "video")
                }
                Divider()
                Button(action: { /* Mute Notifications */ }) {
                    Label("Mute Notifications", systemImage: "bell.slash")
                }
                Button(action: { /* Block */ }) {
                    Label("Block", systemImage: "person.crop.circle.badge.minus")
                }
                
            case .group:
                Button(action: { /* View Members */ }) {
                    Label("View Members", systemImage: "person.2")
                }
                Button(action: { /* Group Info */ }) {
                    Label("Group Info", systemImage: "info.circle")
                }
                Divider()
                Button(action: { /* Mute Notifications */ }) {
                    Label("Mute Notifications", systemImage: "bell.slash")
                }
                Button(action: { /* Leave Group */ }) {
                    Label("Leave Group", systemImage: "rectangle.portrait.and.arrow.right")
                }
                
            case .publicSpace:
                Button(action: { /* Space Info */ }) {
                    Label("Space Info", systemImage: "info.circle")
                }
                Button(action: { /* View Members */ }) {
                    Label("View Members", systemImage: "person.2")
                }
                Divider()
                Button(action: { /* Mute Notifications */ }) {
                    Label("Mute Notifications", systemImage: "bell.slash")
                }
                Button(action: { /* Leave Space */ }) {
                    Label("Leave Space", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }
    
    // MARK: - Messages List
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    // Messages with date dividers
                    ForEach(Array(messagesWithDividers.enumerated()), id: \.offset) { index, item in
                        if let divider = item as? DateDivider {
                            dateDividerView(divider)
                        } else if let message = item as? ChatMessage {
                            VStack(spacing: 8) {
                                messageView(message)
                                
                            }
                        } else if item is NewMessageIndicator {
                            newMessageIndicatorView()
                        }
                    }
                    
                    // Bottom spacer to ensure we can scroll to the very bottom
                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
            }
            .onAppear {
                // Scroll to bottom when the view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
        }
    }
    
    // MARK: - Messages with Dividers
    private var messagesWithDividers: [Any] {
        var items: [Any] = []
        
        // Group messages by date and add dividers
        let calendar = Calendar.current
        var currentDate: Date?
        
        let sortedMessages = messages.sorted(by: { $0.timestamp < $1.timestamp })
        
        // Find the last read message to determine where to place the "New" indicator
        let lastReadMessage = sortedMessages.last { !$0.hasNewMessage }
        let newestUnreadMessage = sortedMessages.last { $0.hasNewMessage }
        let newestUnreadDate = newestUnreadMessage.map { calendar.startOfDay(for: $0.timestamp) }
        
        for message in sortedMessages {
            let messageDate = calendar.startOfDay(for: message.timestamp)
            
            // If this is a new date, add a date divider first
            if currentDate != messageDate {
                // Don't show "New" indicator on date dividers - use standalone indicator instead
                let shouldShowNewIndicator = false
                let divider = DateDivider(
                    date: messageDate,
                    formattedDate: formatDate(messageDate),
                    hasNewMessage: shouldShowNewIndicator
                )
                items.append(divider)
                currentDate = messageDate
            }
            
            // Add standalone "New" indicator before the newest unread message
            if message.id == newestUnreadMessage?.id {
                items.append(NewMessageIndicator())
            }
            
            // Add the message
            items.append(message)
        }
        
        return items
    }
    
    // MARK: - Date Divider View
    private func dateDividerView(_ divider: DateDivider) -> some View {
        VStack(spacing: 0) {
            HStack {
                // Left align with same inset as message content (72px from Figma spec)
                Text(divider.formattedDate)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.quaternary)
                    .padding(.leading, 68) // Align with message text content
                
                Spacer()
                
                // New message indicator - only show when there are unread messages for this date
                if divider.hasNewMessage {
                    Text("New")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.88, green: 0.18, blue: 0.18)) // #e02f2f - MessagingRed from Figma
                        .padding(.trailing, 16) // Align with message content
                }
            }
            .padding(.vertical, 8)
            
            // Divider line - use red color when showing "New" indicator
            Rectangle()
                .fill(divider.hasNewMessage ? Color(red: 0.88, green: 0.18, blue: 0.18) : Color(red: 0.89, green: 0.91, blue: 0.92)) // Red when new, otherwise #e4e7eb - Separators/Opaque from Figma
                .frame(height: 1)
                .padding(.leading, 68) // Align with date text
                .padding(.trailing, 16) // Add right padding to match message content
        }
    }
    
    // MARK: - New Message Indicator View
    private func newMessageIndicatorView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                // New message indicator
                Text("New")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.88, green: 0.18, blue: 0.18)) // #e02f2f - MessagingRed from Figma
                    .padding(.trailing, 16) // Align with message content
            }
            .padding(.vertical, 8)
            
            // Divider line - red color to match the "New" text
            Rectangle()
                .fill(Color(red: 0.88, green: 0.18, blue: 0.18)) // #e02f2f - MessagingRed from Figma
                .frame(height: 1)
                .padding(.leading, 68) // Align with message content
                .padding(.trailing, 16) // Add right padding to match message content
        }
    }
    
    // MARK: - Message View
    private func messageView(_ message: ChatMessage) -> some View {
        // Get cached avatar image if available
        let cachedAvatarImage: Image?
        if let imageIndex = message.sender.avatarImageIndex {
            let cacheKey = "\(message.sender.id)_\(imageIndex)"
            cachedAvatarImage = cachedAvatars[cacheKey]
        } else {
            cachedAvatarImage = nil
        }
        
        return Message(
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
                avatarImageName: message.sender.avatarImageName,
                groupAvatarImageIndices: nil,
                createdAt: message.timestamp,
                mediaAttachments: message.mediaAttachments
            ),
            variant: .full,
            context: .conversation,
            onTap: {
                onMessageTap?(message)
            },
            cachedAvatarImage: cachedAvatarImage
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
    
    private func testNetworkConnectivity() {
        print("🌐 Testing network connectivity...")
        guard let url = URL(string: "https://httpbin.org/get") else {
            print("❌ Invalid test URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Network test failed: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("✅ Network test successful: HTTP \(httpResponse.statusCode)")
                } else {
                    print("✅ Network test successful: Got response")
                }
            }
        }.resume()
    }
    
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ChatView(
            context: .dm(participant: ChatParticipant(
                id: "1",
                name: "Mike Walero",
                avatarImageIndex: 0,
                avatarImageName: nil,
                isOnline: true
            )),
            messages: [
                ChatMessage(
                    id: "1",
                    sender: ChatParticipant(
                        id: "1",
                        name: "Mike Walero",
                        avatarImageIndex: 0,
                        avatarImageName: nil,
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
                        avatarImageIndex: 1,
                        avatarImageName: nil,
                        isOnline: true
                    ),
                    content: "Not much, just working on the new features. How about you?",
                    timestamp: Date().addingTimeInterval(-1800),
                    hasReplies: false,
                    replyCount: 0,
                    replyAvatars: [],
                    hasNewMessage: false,
                    mediaAttachments: nil
                ),
                ChatMessage(
                    id: "3",
                    sender: ChatParticipant(
                        id: "1",
                        name: "Mike Walero",
                        avatarImageIndex: 0,
                        avatarImageName: nil,
                        isOnline: true
                    ),
                    content: "Just finished reviewing the design mockups. They look great!",
                    timestamp: Date().addingTimeInterval(-900),
                    hasReplies: false,
                    replyCount: 0,
                    replyAvatars: [],
                    hasNewMessage: false,
                    mediaAttachments: nil
                ),
                ChatMessage(
                    id: "4",
                    sender: ChatParticipant(
                        id: "2",
                        name: "Sarah Chen",
                        avatarImageIndex: 1,
                        avatarImageName: nil,
                        isOnline: true
                    ),
                    content: "Awesome! I'll start implementing them tomorrow. Thanks for the feedback!",
                    timestamp: Date().addingTimeInterval(-300),
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
