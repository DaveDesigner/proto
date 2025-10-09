//
//  Notification.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

// MARK: - Notification Types
enum NotificationType: String, CaseIterable {
    case like = "Like"
    case comment = "Comment"
    case mention = "Mention"
    case reply = "Reply"
    case event = "Event"
    case live = "Live"
    case alert = "Alert"
    case poll = "Poll"
    case post = "Post"
    case ai = "AI"
    
    var badgeColor: Color {
        switch self {
        case .alert, .like, .live, .event:
            return .notificationRed
        case .mention:
            return .notificationOrange
        case .comment:
            return .notificationTeal
        case .post, .poll:
            return .notificationYellow
        case .reply, .ai:
            return .notificationPurple
        }
    }
    
    var iconName: String {
        switch self {
        case .like:
            return "heart.fill"
        case .comment:
            return "message.fill"
        case .mention:
            return "at"
        case .reply:
            return "arrowshape.turn.up.left.fill"
        case .event:
            return "calendar"
        case .live:
            return "video.fill"
        case .alert:
            return "exclamationmark.triangle.fill"
        case .poll:
            return "chart.bar.fill"
        case .post:
            return "doc.text.fill"
        case .ai:
            return "sparkles"
        }
    }
}

// MARK: - Notification Data Model
struct NotificationData: Identifiable {
    let id = UUID()
    let type: NotificationType
    let userName: String
    let userInitials: String
    let action: String  // e.g., "has liked your comment", "wants to connect", "is going live"
    let content: String?  // e.g., "After Circle App iOS update", "Product Demo", "Which color scheme do you prefer?"
    let timestamp: String
    let isNew: Bool
    let hasActions: Bool
    let actionTitle: String?
    let actionSubtitle: String?
    let imageIndex: Int?
    let secondImageIndex: Int?
    let isGroupAvatar: Bool
    let isAI: Bool
    
    // Computed property for backward compatibility
    var message: String {
        if let content = content {
            return "\(userName) \(action) \(content)"
        } else {
            return "\(userName) \(action)"
        }
    }
}

// MARK: - Notification Badge Component
struct NotificationBadge: View {
    let type: NotificationType
    
    var body: some View {
        ZStack {
            Circle()
                .fill(type.badgeColor)
                .frame(width: 20, height: 20)
            
            Image(systemName: type.iconName)
                .font(.system(size: 8, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Main Notification Component
struct Notification: View {
    let data: NotificationData
    @Binding var selectedTintColor: Color
    @StateObject private var unsplashService = UnsplashService.shared
    @Environment(\.colorScheme) private var colorScheme
    
    // Computed properties for adaptive accent color and text contrast
    private var adaptiveAccentColor: Color {
        // Use primary color directly - it already adapts to light/dark mode
        return Color.primary
    }
    
    private var acceptButtonTextColor: Color {
        // Primary color is dark in light mode, light in dark mode
        // So we need light text in light mode, dark text in dark mode
        return colorScheme == .light ? .white : .black
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Avatar with notification badge
            ZStack(alignment: .bottomTrailing) {
                if data.isGroupAvatar {
                    // Group avatar
                    ZStack {
                        // First avatar (background) - top left
                        groupAvatarImage
                            .frame(width: 28, height: 28)
                            .offset(x: -6, y: -6)
                        
                        // Second avatar (foreground) - bottom right with stroke
                        ZStack {
                            // White stroke background
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                            
                            // Second avatar image
                            secondGroupAvatarImage
                                .frame(width: 28, height: 28)
                        }
                        .offset(x: 6, y: 6)
                        
                        // Group initials overlay
                        if data.isAI {
                            Text(data.userInitials)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                                .offset(x: 6, y: 6)
                        }
                    }
                    .frame(width: 40, height: 40)
                } else {
                    // Single avatar
                    Avatar(
                        initials: data.userInitials,
                        variant: .default(size: 40),
                        imageIndex: data.imageIndex
                    )
                }
                
                // Notification badge
                if !data.isAI {
                    NotificationBadge(type: data.type)
                        .offset(x: 6, y: 6)
                }
            }
            .frame(width: 40, height: 40)
            
            // Notification content
            VStack(alignment: .leading, spacing: 4) {
                if data.isAI {
                    // AI notification with special styling
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.59, green: 0.46, blue: 0.97))
                        
                        styledNotificationText
                    }
                    
                    if let actionSubtitle = data.actionSubtitle {
                        Text(attributedSubtitle)
                            .lineLimit(1)
                    }
                } else {
                    // Regular notification with styled text
                    styledNotificationText
                }
                
                // Timestamp and actions
                HStack(alignment: .top) {
                    Text(data.timestamp)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.tertiary)
                    
                    Spacer()
                    
                    if data.hasActions {
                        HStack(spacing: 8) {
                            Button(action: {}) {
                                Text("Ignore")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundColor(.secondary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .glassEffect(.regular.interactive())
                            
                            Button(action: {}) {
                                Text("Accept")
                                    .font(.footnote.weight(.semibold))
                                    .foregroundColor(acceptButtonTextColor)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .glassEffect(.regular.tint(adaptiveAccentColor).interactive())
                        }
                    }
                }
            }
            
            // New indicator
            if data.isNew {
                VStack {
                    Circle()
                        .fill(Color(red: 0.26, green: 0.38, blue: 0.94))
                        .frame(width: 8, height: 8)
                    Spacer()
                }
                .frame(width: 8)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 0)
    }
    
    // MARK: - Styled Text
    
    private var styledNotificationText: some View {
        Text(attributedMessage)
            .lineLimit(2)
    }
    
    private var attributedMessage: AttributedString {
        var attributedString = AttributedString(data.message)
        
        // Apply base styling
        attributedString.font = .system(size: 15, weight: .regular)
        attributedString.foregroundColor = .primary
        
        // Style the user name (always first)
        if let range = attributedString.range(of: data.userName) {
            attributedString[range].font = .system(size: 15, weight: .semibold)
        }
        
        // Style the content (if it exists)
        if let content = data.content {
            if let range = attributedString.range(of: content) {
                attributedString[range].font = .system(size: 15, weight: .semibold)
            }
        }
        
        return attributedString
    }
    
    private var attributedSubtitle: AttributedString {
        guard let subtitle = data.actionSubtitle else { return AttributedString("") }
        
        var attributedString = AttributedString(subtitle)
        
        // Apply base styling
        attributedString.font = .system(size: 15, weight: .regular)
        attributedString.foregroundColor = .primary
        
        return attributedString
    }
    
    // MARK: - Group Avatar Images
    
    private var groupAvatarImage: some View {
        Group {
            if let imageIndex = data.imageIndex, 
                      let photo = unsplashService.getPhoto(at: imageIndex) {
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(avatarColor)
                        .overlay(
                            Text(data.userInitials)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
            } else {
                Circle()
                    .fill(avatarColor)
                    .overlay(
                        Text(data.userInitials)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
        }
    }
    
    private var secondGroupAvatarImage: some View {
        Group {
            if let secondImageIndex = data.secondImageIndex, 
                      let photo = unsplashService.getPhoto(at: secondImageIndex) {
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(secondAvatarColor)
                        .overlay(
                            Text(data.userInitials)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
            } else {
                Circle()
                    .fill(secondAvatarColor)
                    .overlay(
                        Text(data.userInitials)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
        }
    }
    
    private let colors = [
        Color(red: 0.447, green: 0.188, blue: 0.737), // Purple
        Color(red: 0.702, green: 0.192, blue: 0.745), // Pink
        Color(red: 0.745, green: 0.173, blue: 0.502), // Magenta
        Color(red: 0.141, green: 0.400, blue: 0.576), // Blue
        Color(red: 0.114, green: 0.373, blue: 0.412), // Teal
        Color(red: 0.227, green: 0.412, blue: 0.109)  // Green
    ]
    
    private var avatarColor: Color {
        let hash = data.userInitials.hashValue
        return colors[abs(hash) % colors.count]
    }
    
    private var secondAvatarColor: Color {
        return Color(red: 0.702, green: 0.192, blue: 0.745) // Pink
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 0) {
            // Like notification
            Notification(data: NotificationData(
                type: .like,
                userName: "Caryn Juen",
                userInitials: "CJ",
                action: "has liked your comment in post",
                content: "After Circle App iOS update",
                timestamp: "50 mins ago",
                isNew: true,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: nil,
                imageIndex: 0,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ), selectedTintColor: .constant(Color.blue))
            
            Divider()
            
            // Connection request with actions
            Notification(data: NotificationData(
                type: .mention,
                userName: "Caryn Juen",
                userInitials: "CJ",
                action: "wants to connect with you",
                content: nil,
                timestamp: "Yesterday",
                isNew: true,
                hasActions: true,
                actionTitle: "Connect",
                actionSubtitle: nil,
                imageIndex: 1,
                secondImageIndex: nil,
                isGroupAvatar: false,
                isAI: false
            ), selectedTintColor: .constant(Color.blue))
            
            Divider()
            
            // AI notification with group avatar
            Notification(data: NotificationData(
                type: .ai,
                userName: "Caryn Juen",
                userInitials: "CP",
                action: "paused conversation",
                content: nil,
                timestamp: "Mar 26",
                isNew: true,
                hasActions: false,
                actionTitle: nil,
                actionSubtitle: "with Calvin Parks",
                imageIndex: 2,
                secondImageIndex: 3,
                isGroupAvatar: true,
                isAI: true
            ), selectedTintColor: .constant(Color.blue))
        }
    }
}
