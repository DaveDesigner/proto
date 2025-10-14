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
    let avatarImageName: String? // For static assets
    let groupAvatarImageIndices: [Int]? // Indices for group chat Unsplash images
    let createdAt: Date? // For relative date formatting
    let mediaAttachments: [MediaAttachment]? // Media attachments for the message
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
    let isButton: Bool
    let cachedAvatarImage: Image?
    
    @ObservedObject private var unsplashService = UnsplashService.shared
    
    init(data: MessageData, variant: MessageVariant = .full, onTap: (() -> Void)? = nil, isButton: Bool = true, cachedAvatarImage: Image? = nil) {
        self.data = data
        self.variant = variant
        self.onTap = onTap
        self.isButton = isButton
        self.cachedAvatarImage = cachedAvatarImage
    }
    
    var body: some View {
        let content = HStack(alignment: .top, spacing: 12) {
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
        
        if isButton {
            return AnyView(
                Button(action: {
                    onTap?()
                }) {
                    content
                }
                .buttonStyle(PlainButtonStyle())
            )
        } else {
            return AnyView(content)
        }
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
                // Single avatar - use cached image if available, otherwise fall back to Avatar component
                let variant: AvatarVariant = data.isOnline ? .online() : .default()
                
                if let cachedImage = cachedAvatarImage {
                    // Use cached image directly
                    ZStack {
                        cachedImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        if data.isOnline {
                            // Add online indicator
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 12, height: 12)
                                
                                Circle()
                                    .fill(Color(red: 0, green: 0.54, blue: 0.18))
                                    .frame(width: 8, height: 8)
                            }
                            .offset(x: 14, y: 14)
                        }
                    }
                } else {
                    // Fall back to Avatar component
                    Avatar(
                        initials: data.senderName,
                        imageName: data.avatarImageName,
                        variant: variant,
                        imageIndex: data.avatarImageIndex
                    )
                }
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
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                RelativeDate(date: data.createdAt ?? Date(), variant: .messages, foregroundColor: Color.quaternary)
            }
            
            Spacer(minLength: 0)
            
            // New message indicator - only in full variant
            if variant == .full && data.hasNewMessage {
                Text("New")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.88, green: 0.18, blue: 0.18)) // #e02f2f - MessagingRed from Figma
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
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            
            // Media attachments section
            if let attachments = data.mediaAttachments, !attachments.isEmpty {
                attachmentsSection(attachments)
            }
        }
    }
    
    // MARK: - Preview Message Content
    private var previewMessageContent: some View {
        Text(previewText)
            .font(.body)
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
    
    // MARK: - Attachments Section
    private func attachmentsSection(_ attachments: [MediaAttachment]) -> some View {
        HStack(spacing: 5) {
            ForEach(attachments, id: \.id) { attachment in
                attachmentView(attachment)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Individual Attachment View
    private func attachmentView(_ attachment: MediaAttachment) -> some View {
        Group {
            switch attachment.type {
            case .image:
                imageAttachmentView(attachment)
            case .video:
                videoAttachmentView(attachment)
            case .file:
                fileAttachmentView(attachment)
            }
        }
    }
    
    // MARK: - Image Attachment View
    @ViewBuilder
    private func imageAttachmentView(_ attachment: MediaAttachment) -> some View {
        // Use the imageIndex from the attachment, with fallback to 0
        let imageIndex = attachment.imageIndex ?? 0
        
        // Create a stable view component with a stable identity
        MessageAttachmentImageView(
            attachmentId: attachment.id,
            imageIndex: imageIndex
        )
        .id("attachment-\(attachment.id)-\(imageIndex)") // Stable identity to prevent recreation
    }
    
    // MARK: - Video Attachment View
    private func videoAttachmentView(_ attachment: MediaAttachment) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 150)
            .overlay(
                VStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Video")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            )
    }
    
    // MARK: - File Attachment View
    private func fileAttachmentView(_ attachment: MediaAttachment) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "doc.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(attachment.name ?? "File")
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("Tap to download")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(16)
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
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Message Attachment Image View
struct MessageAttachmentImageView: View {
    let attachmentId: String
    let imageIndex: Int
    
    @ObservedObject private var unsplashService = UnsplashService.shared
    @State private var loadedImage: Image?
    @State private var isLoading = true
    @State private var hasError = false
    @Namespace private var animationNamespace
    
    var body: some View {
        Group {
            if let loadedImage = loadedImage {
                // Show the loaded image with lightbox support
                loadedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 200)
                    .clipped()
                    .cornerRadius(16)
                    .matchedTransitionSource(
                        id: "chat-attachment-\(attachmentId)",
                        in: animationNamespace
                    )
                    .lightboxNavigation(
                        imageURL: getImageURL(),
                        sourceImage: loadedImage,
                        sourceID: "chat-attachment-\(attachmentId)",
                        namespace: animationNamespace
                    )
            } else if hasError {
                // Show error state
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.3))
                    .frame(height: 150)
                    .overlay(
                        VStack {
                            Text("❌ Failed to load")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    )
            } else if isLoading {
                // Show loading state
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 150)
                    .overlay(
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Loading image...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func getImageURL() -> URL? {
        guard let photo = unsplashService.getPhoto(at: imageIndex) else {
            return nil
        }
        return URL(string: photo.urls.full)
    }
    
    private func loadImage() {
        guard let photo = unsplashService.getPhoto(at: imageIndex) else {
            hasError = true
            isLoading = false
            return
        }
        
        guard let url = URL(string: photo.urls.regular) else {
            hasError = true
            isLoading = false
            return
        }
        
        // Load the image asynchronously
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    await MainActor.run {
                        self.loadedImage = image
                        self.isLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.hasError = true
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.hasError = true
                    self.isLoading = false
                }
            }
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
            avatarImageName: nil,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3600), // 1 hour ago
            mediaAttachments: nil
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
            avatarImageName: nil,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-7200), // 2 hours ago
            mediaAttachments: nil
        ))
        
        Divider()
        
        // Message with image attachment to test the fix
        Message(data: MessageData(
            id: "4",
            senderName: "Sarah Chen",
            timestamp: "2:45 pm",
            messages: ["Check out this landscape image!"],
            hasReplies: false,
            replyCount: 0,
            replyAvatars: [],
            hasNewMessage: false,
            isOnline: true,
            isGroupChat: false,
            groupAvatars: nil,
            avatarImageIndex: 2,
            avatarImageName: nil,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-3600), // 1 hour ago
            mediaAttachments: [
                MediaAttachment(id: "img1", type: .image, name: "landscape.jpg", imageIndex: 0)
            ]
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
            avatarImageName: nil,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-86400), // Yesterday
            mediaAttachments: nil
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
            avatarImageName: nil,
            groupAvatarImageIndices: [3, 4],
            createdAt: Date().addingTimeInterval(-172800), // 2 days ago
            mediaAttachments: nil
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
            avatarImageName: nil,
            groupAvatarImageIndices: nil,
            createdAt: Date().addingTimeInterval(-604800), // 1 week ago
            mediaAttachments: nil
        ), variant: .preview)
    }
    .background(Color(.systemBackground))
}
