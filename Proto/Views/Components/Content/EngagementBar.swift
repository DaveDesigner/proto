//
//  EngagementBar.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=5-2434&p=f&t=yPG9JEmux6qoTlmT-11
//

import SwiftUI

struct EngagementBar: View {
    @State private var likeCount: Int
    @State private var commentCount: Int
    @State private var isLiked: Bool
    let onLikeTapped: (() -> Void)?
    let onCommentTapped: (() -> Void)?
    
    init(
        likeCount: Int = 0,
        commentCount: Int = 0,
        isLiked: Bool = false,
        onLikeTapped: (() -> Void)? = nil,
        onCommentTapped: (() -> Void)? = nil
    ) {
        self._likeCount = State(initialValue: likeCount)
        self._commentCount = State(initialValue: commentCount)
        self._isLiked = State(initialValue: isLiked)
        self.onLikeTapped = onLikeTapped
        self.onCommentTapped = onCommentTapped
    }
    
    var body: some View {
        HStack(spacing: 24) {
            // Like button with count
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isLiked {
                        // Unliking: switch to stroke and decrease count
                        isLiked = false
                        likeCount = max(0, likeCount - 1)
                    } else {
                        // Liking: switch to filled and increase count
                        isLiked = true
                        likeCount += 1
                    }
                }
                onLikeTapped?()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: isLiked ? .medium : .regular))
                        .foregroundColor(isLiked ? .red : .secondary)
                        .scaleEffect(isLiked ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isLiked)
                    
                    Text(formatCount(likeCount))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                        .animation(.easeInOut(duration: 0.2), value: likeCount)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Comment button with count
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    commentCount += 1
                }
                onCommentTapped?()
            }) {
                HStack(spacing: 8) {
                    Image("Comment20")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.secondary)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 0.1), value: commentCount)
                    
                    Text(formatCount(commentCount))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                        .animation(.easeInOut(duration: 0.2), value: commentCount)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.trailing, 20)
        .frame(height: 20)
    }
    
    private func formatCount(_ count: Int) -> String {
        if count >= 1000 {
            let thousands = Double(count) / 1000.0
            if thousands >= 10 {
                return String(format: "%.0fK", thousands)
            } else {
                return String(format: "%.1fK", thousands)
            }
        } else {
            return "\(count)"
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Default state
        EngagementBar()
        
        // With counts
        EngagementBar(
            likeCount: 42,
            commentCount: 8
        )
        
        // Liked state with high counts
        EngagementBar(
            likeCount: 1245,
            commentCount: 1249,
            isLiked: true
        )
        
        // Very high counts
        EngagementBar(
            likeCount: 15000,
            commentCount: 2500,
            isLiked: true
        )
        
        // With action handlers
        EngagementBar(
            likeCount: 99,
            commentCount: 12,
            isLiked: false,
            onLikeTapped: {
                print("Like tapped!")
            },
            onCommentTapped: {
                print("Comment tapped!")
            }
        )
    }
    .padding()
}
