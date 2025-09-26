//
//  PostPreview.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=5-62&p=f&t=yPG9JEmux6qoTlmT-11
//

import SwiftUI

struct PostPreview: View {
    let authorName: String
    let spaceName: String
    let createdAt: Date
    let avatarInitials: String?
    let avatarImageName: String?
    let postTitle: String
    let postDescription: String
    let postImageName: String?
    let likeCount: Int
    let commentCount: Int
    let isLiked: Bool
    let onLikeTapped: (() -> Void)?
    let onCommentTapped: (() -> Void)?
    
    @StateObject private var unsplashService = UnsplashService.shared
    
    // Static counter to ensure sequential image assignment
    private static var imageCounter = 0
    
    init(
        authorName: String,
        spaceName: String,
        createdAt: Date,
        avatarInitials: String? = nil,
        avatarImageName: String? = nil,
        postTitle: String,
        postDescription: String,
        postImageName: String? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        isLiked: Bool = false,
        onLikeTapped: (() -> Void)? = nil,
        onCommentTapped: (() -> Void)? = nil
    ) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.createdAt = createdAt
        self.avatarInitials = avatarInitials
        self.avatarImageName = avatarImageName
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.postImageName = postImageName
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLiked = isLiked
        self.onLikeTapped = onLikeTapped
        self.onCommentTapped = onCommentTapped
    }
    
    // Convenience initializer for backward compatibility
    init(
        authorName: String,
        spaceName: String,
        timeAgo: String,
        avatarInitials: String? = nil,
        avatarImageName: String? = nil,
        postTitle: String,
        postDescription: String,
        postImageName: String? = nil,
        likeCount: Int = 0,
        commentCount: Int = 0,
        isLiked: Bool = false,
        onLikeTapped: (() -> Void)? = nil,
        onCommentTapped: (() -> Void)? = nil
    ) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.createdAt = Date() // Fallback to current date
        self.avatarInitials = avatarInitials
        self.avatarImageName = avatarImageName
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.postImageName = postImageName
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLiked = isLiked
        self.onLikeTapped = onLikeTapped
        self.onCommentTapped = onCommentTapped
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Post metadata
            PostMetadata(
                authorName: authorName,
                spaceName: spaceName,
                createdAt: createdAt,
                avatarInitials: avatarInitials,
                avatarImageName: avatarImageName
            )
            
            // Post content
            VStack(alignment: .leading, spacing: 8) {
                // Post title
                Text(postTitle)
                    .font(.title3.weight(.bold))
                    .foregroundColor(Color.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Post description
                Text(postDescription)
                    .font(.body)
                    .foregroundColor(Color.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            // Post image
            if let postImageName = postImageName {
                // Use simple sequential assignment based on postImageName
                let imageIndex = getSequentialImageIndex(from: postImageName)
                
                if unsplashService.featuredPhotos.isEmpty {
                    // Show loading state while photos are being fetched
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                ProgressView()
                                Text("Loading image...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                } else {
                    unsplashService.createPostImage(imageIndex: imageIndex)
                }
            }
            
            // Engagement bar
            EngagementBar(
                likeCount: likeCount,
                commentCount: commentCount,
                isLiked: isLiked,
                onLikeTapped: onLikeTapped,
                onCommentTapped: onCommentTapped
            )
        }
    }
    
    private func getSequentialImageIndex(from postImageName: String) -> Int {
        // Simple sequential assignment: image1 -> 0, image2 -> 1, image3 -> 2, etc.
        if postImageName.hasPrefix("image") {
            let numberString = String(postImageName.dropFirst(5)) // Remove "image" prefix
            if let number = Int(numberString) {
                return (number - 1) % 7 // Convert to 0-based index, cycle through 7 images
            }
        }
        // Fallback: use the counter for any other naming pattern
        let currentIndex = PostPreview.imageCounter
        PostPreview.imageCounter += 1
        return currentIndex % 7
    }
    
    /// Reset the image counter (useful for testing or app restart)
    static func resetImageCounter() {
        imageCounter = 0
    }
    
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            // Post with text content
            PostPreview(
                authorName: "Alex Johnson",
                spaceName: "Design Team",
                createdAt: Date().addingTimeInterval(-7200), // 2 hours ago
                avatarInitials: "AJ",
                postTitle: "New Design System Components",
                postDescription: "We've just released a comprehensive set of design system components that will help us maintain consistency across all our products. This includes buttons, forms, cards, and navigation elements.",
                postImageName: nil,
                likeCount: 42,
                commentCount: 8,
                isLiked: false,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
            )
            
            // Post without image
            PostPreview(
                authorName: "Sarah Chen",
                spaceName: "Engineering",
                createdAt: Date().addingTimeInterval(-345600), // 4 days ago
                avatarInitials: "SC",
                postTitle: "Weekly Engineering Update",
                postDescription: "This week we focused on performance optimizations and bug fixes. The new caching system is showing promising results with 40% faster load times.",
                likeCount: 156,
                commentCount: 23,
                isLiked: true,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
            )
            
            // Post with research content
            PostPreview(
                authorName: "Dr. Elizabeth Thompson",
                spaceName: "Research and Development",
                createdAt: Date().addingTimeInterval(-604800), // 1 week ago
                avatarInitials: "ET",
                postTitle: "Advanced Machine Learning Techniques for Natural Language Processing",
                postDescription: "Our research team has been exploring cutting-edge transformer architectures and their applications in understanding context and generating human-like responses. The results are quite promising and we're excited to share our findings with the community.",
                postImageName: nil,
                likeCount: 1245,
                commentCount: 89,
                isLiked: false,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
            )
            
            // Post with team update
            PostPreview(
                authorName: "Mike Rodriguez",
                spaceName: "Product Team",
                createdAt: Date().addingTimeInterval(-259200), // 3 days ago
                avatarInitials: "MR",
                postTitle: "Team Collaboration Update",
                postDescription: "Great progress on our latest feature! The team has been working closely together and we're seeing excellent results.",
                postImageName: nil,
                likeCount: 67,
                commentCount: 12,
                isLiked: true,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
