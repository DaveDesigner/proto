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
    let timeAgo: String
    let avatarInitials: String?
    let avatarImageName: String?
    
    init(authorName: String, spaceName: String, timeAgo: String, avatarInitials: String? = nil, avatarImageName: String? = nil) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.timeAgo = timeAgo
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
                        .foregroundStyle(.secondary)
                        .layoutPriority(3)
                    
                    // "in" connector - regular weight
                    Text(" in ")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                        .layoutPriority(1)
                    
                    // Space name - lowest priority (can truncate), medium weight
                    Text(spaceName)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .layoutPriority(1)
                    
                    // Time - medium priority (preferred to be visible), regular weight
                    Text(" • \(timeAgo)")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.secondary)
                        .layoutPriority(2)
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
            timeAgo: "4d",
            avatarInitials: "SF"
        )
        
        // Long author name with truncation
        PostMetadata(
            authorName: "Aleksandriya Patel",
            spaceName: "Space Name",
            timeAgo: "Mar 27",
            avatarInitials: "AP"
        )
        
        // Long space name with truncation
        PostMetadata(
            authorName: "Short Name",
            spaceName: "Long Space Name Truncation for Testing",
            timeAgo: "2w",
            avatarInitials: "SN"
        )
        
        // Very long names to test truncation
        PostMetadata(
            authorName: "Tom Harrison",
            spaceName: "Longer than average Space Name",
            timeAgo: "Mar 27, 2023",
            avatarInitials: "TH"
        )
        
        // Image avatar
        PostMetadata(
            authorName: "Alex Johnson",
            spaceName: "Design Team",
            timeAgo: "2h",
            avatarImageName: "Avatar"
        )
    }
    .padding()
}
