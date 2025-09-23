//
//  PostMetadata.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/file/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=2-232
//

import SwiftUI

struct PostMetadata: View {
    let authorName: String
    let spaceName: String
    let createdAt: Date
    let avatarInitials: String?
    let avatarImageName: String?
    
    init(authorName: String, spaceName: String, createdAt: Date, avatarInitials: String? = nil, avatarImageName: String? = nil) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.createdAt = createdAt
        self.avatarInitials = avatarInitials
        self.avatarImageName = avatarImageName
    }
    
    // Convenience initializer for backward compatibility
    init(authorName: String, spaceName: String, timeAgo: String, avatarInitials: String? = nil, avatarImageName: String? = nil) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.createdAt = Date() // Fallback to current date
        self.avatarInitials = avatarInitials
        self.avatarImageName = avatarImageName
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Avatar - 24x24 as specified in Figma
            Avatar(
                initials: avatarInitials,
                imageName: avatarImageName,
                size: 24
            )
            
            // Metadata section with intelligent width behavior using concatenated strings
            HStack(spacing: 4) {
                // Concatenated text with different priorities and font weights
                HStack(spacing: 0) {
                    // Author name - highest priority (always visible), medium weight
                    Text(authorName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.tertiary)
                        .layoutPriority(2)
                    
                    // "in" connector - regular weight
                    Text(" in ")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.tertiary)
                        .layoutPriority(2)
                    
                    // Space name - lowest priority (can truncate), medium weight
                    Text(spaceName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.tertiary)
                        .layoutPriority(2)
                    
                    // Time - medium priority (preferred to be visible), regular weight
                    HStack(spacing: 0) {
                        Text(" • ")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color.tertiary)
                            .layoutPriority(1)
                        
                        RelativeDate(date: createdAt, variant: .abbreviated)
                            .layoutPriority(1) // Protect the date from truncation
                    }
                }
                .lineLimit(1)
                .truncationMode(.tail)
            }
        }
    }
}


// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Normal state
        PostMetadata(
            authorName: "Sally Flower",
            spaceName: "Space Name",
            createdAt: Date().addingTimeInterval(-345600), // 4 days ago
            avatarInitials: "SF"
        )
        
        // Long author name with truncation
        PostMetadata(
            authorName: "Aleksandriya Patel",
            spaceName: "Space Name",
            createdAt: Date().addingTimeInterval(-15552000), // 6 months ago
            avatarInitials: "AP"
        )
        
        // Long space name with truncation
        PostMetadata(
            authorName: "Short Name",
            spaceName: "Long Space Name Truncation for Testing",
            createdAt: Date().addingTimeInterval(-1209600), // 2 weeks ago
            avatarInitials: "SN"
        )
        
        // Very long names to test truncation
        PostMetadata(
            authorName: "Tom Harrison",
            spaceName: "Longer than average Space Name",
            createdAt: Date().addingTimeInterval(-31536000), // 1 year ago
            avatarInitials: "TH"
        )
        
        // Image avatar
        PostMetadata(
            authorName: "Alex Johnson",
            spaceName: "Design Team",
            createdAt: Date().addingTimeInterval(-7200), // 2 hours ago
            avatarImageName: "Avatar"
        )
        
        // Recent message
        PostMetadata(
            authorName: "Recent User",
            spaceName: "Recent Space",
            createdAt: Date().addingTimeInterval(-300), // 5 minutes ago
            avatarInitials: "RU"
        )
    }
    .padding()
}
