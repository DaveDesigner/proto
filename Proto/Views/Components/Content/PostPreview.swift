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
    let timeAgo: String
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
    let onPostTapped: (() -> Void)?
    
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
        onCommentTapped: (() -> Void)? = nil,
        onPostTapped: (() -> Void)? = nil
    ) {
        self.authorName = authorName
        self.spaceName = spaceName
        self.timeAgo = timeAgo
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
        self.onPostTapped = onPostTapped
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Post metadata
            PostMetadata(
                authorName: authorName,
                spaceName: spaceName,
                timeAgo: timeAgo,
                avatarInitials: avatarInitials,
                avatarImageName: avatarImageName
            )
            
            // Post content
            VStack(alignment: .leading, spacing: 8) {
                // Post title
                Text(postTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Post description
                Text(postDescription)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            
            // Optional post image - use Unsplash for placeholder images
            if let postImageName = postImageName {
                if UIImage(named: postImageName) != nil {
                    // Use local image if available
                    Image(postImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(16)
                } else {
                    // Use Unsplash placeholder for demonstration
                    let searchTerm = getSearchTermForImageName(postImageName)
                    UnsplashService.shared.createAsyncImage(
                        width: 400,
                        height: 300,
                        searchTerm: searchTerm
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(16)
                    }
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
        .onTapGesture {
            onPostTapped?()
        }
    }
    
    // Helper function to get appropriate search terms for different image types
    private func getSearchTermForImageName(_ imageName: String?) -> String {
        guard let imageName = imageName else { return "business meeting office" }
        
        switch imageName.lowercased() {
        case let name where name.contains("ai") || name.contains("technology"):
            return "artificial intelligence technology"
        case let name where name.contains("leadership") || name.contains("executive"):
            return "executive leadership meeting"
        case let name where name.contains("coaching") || name.contains("mentoring"):
            return "business coaching meeting"
        case let name where name.contains("ethics") || name.contains("professional"):
            return "professional business ethics"
        case let name where name.contains("success") || name.contains("achievement"):
            return "business success achievement"
        case let name where name.contains("team") || name.contains("collaboration"):
            return "team collaboration meeting"
        default:
            return "business meeting office"
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            // Post with image
            PostPreview(
                authorName: "Alex Johnson",
                spaceName: "Design Team",
                timeAgo: "2h",
                avatarInitials: "AJ",
                postTitle: "New Design System Components",
                postDescription: "We've just released a comprehensive set of design system components that will help us maintain consistency across all our products. This includes buttons, forms, cards, and navigation elements.",
                postImageName: "Feed",
                likeCount: 42,
                commentCount: 8,
                isLiked: false,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
                onPostTapped: {
                    print("Post tapped!")
                }
            )
            
            // Post without image
            PostPreview(
                authorName: "Sarah Chen",
                spaceName: "Engineering",
                timeAgo: "4d",
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
                onPostTapped: {
                    print("Post tapped!")
                }
            )
            
            // Post with long content
            PostPreview(
                authorName: "Dr. Elizabeth Thompson",
                spaceName: "Research and Development",
                timeAgo: "1w",
                avatarInitials: "ET",
                postTitle: "Advanced Machine Learning Techniques for Natural Language Processing",
                postDescription: "Our research team has been exploring cutting-edge transformer architectures and their applications in understanding context and generating human-like responses. The results are quite promising and we're excited to share our findings with the community.",
                likeCount: 1245,
                commentCount: 89,
                isLiked: false,
                onLikeTapped: {
                    print("Like tapped!")
                },
                onCommentTapped: {
                    print("Comment tapped!")
                },
                onPostTapped: {
                    print("Post tapped!")
                }
            )
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
