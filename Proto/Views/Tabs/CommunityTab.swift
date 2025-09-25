//
//  CommunityTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct CommunityTab: View {
    @State private var currentSort = "Latest"
    @State private var showDraftsSheet = false
    @State private var selectedSegment = 0
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedTintColor: Color
    @StateObject private var unsplashService = UnsplashService.shared
    
    private let communitySegments = ["Feed", "Video", "Courses", "Events", "Members", "Leaderboard"]
    
    private var feedBlendMode: BlendMode {
        colorScheme == .dark ? .screen : .multiply
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 8) {
                    // Segment control for content switching
                    SegmentControl(
                        segments: communitySegments,
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
                        switch communitySegments[selectedSegment] {
                        case "Feed":
                            // Executive coaching community posts showcasing AI transformation
                            VStack(alignment: .leading, spacing: 20) {
                                // Post 1: AI Tools for Executive Coaching
                                NavigationLink(destination: PostDetails()) {
                                    PostPreview(
                                        authorName: "Dr. Sarah Chen",
                                        spaceName: "AI Transformation",
                                        createdAt: Date().addingTimeInterval(-7200), // 2 hours ago
                                        avatarInitials: "SC",
                                        postTitle: "Revolutionary AI Tools for Executive Coaching",
                                        postDescription: "Just discovered how ChatGPT can help executives develop better self-awareness through structured reflection prompts. The results are remarkable!",
                                        postImageName: "image1", // Sequential image assignment
                                        likeCount: 42,
                                        commentCount: 8,
                                        isLiked: false,
                                        onLikeTapped: {
                                            print("Like tapped on AI tools post!")
                                        },
                                        onCommentTapped: {
                                            print("Comment tapped on AI tools post!")
                                        },
                                        onPostTapped: {
                                            print("Post tapped on AI tools!")
                                        }
                                    )
                                }
                                
                                Divider()
                                
                                // Post 2: Leadership Development with AI
                                PostPreview(
                                    authorName: "Marcus Thompson",
                                    spaceName: "Leadership Excellence",
                                    createdAt: Date().addingTimeInterval(-345600), // 4 days ago
                                    avatarInitials: "MT",
                                    postTitle: "How AI is Transforming Leadership Development",
                                    postDescription: "Exploring how AI-powered assessments can identify leadership gaps and create personalized development plans for C-suite executives.",
                                    postImageName: "image2", // Sequential image assignment
                                    likeCount: 156,
                                    commentCount: 23,
                                    isLiked: true,
                                    onLikeTapped: {
                                        print("Like tapped on leadership post!")
                                    },
                                    onCommentTapped: {
                                        print("Comment tapped on leadership post!")
                                    },
                                    onPostTapped: {
                                        print("Post tapped on leadership!")
                                    }
                                )

                                
                                Divider()
                                
                                // Post 3: Executive Coaching Best Practices
                                PostPreview(
                                    authorName: "Dr. Elizabeth Rodriguez-Williams",
                                        spaceName: "Executive Coaching Mastery",
                                        createdAt: Date().addingTimeInterval(-604800), // 1 week ago
                                        avatarInitials: "ER",
                                        postTitle: "The Future of Executive Coaching: Integrating AI and Human Insight",
                                        postDescription: "A comprehensive analysis of how artificial intelligence is reshaping the executive coaching landscape while preserving the essential human elements that make coaching truly transformative.",
                                        postImageName: "image3", // Sequential image assignment
                                        likeCount: 1245,
                                        commentCount: 89,
                                        isLiked: false,
                                        onLikeTapped: {
                                            print("Like tapped on coaching future post!")
                                        },
                                        onCommentTapped: {
                                            print("Comment tapped on coaching future post!")
                                        },
                                        onPostTapped: {
                                            print("Post tapped on coaching future!")
                                        }
                                    )
                                    
                                    Divider()
                                    
                                    // Post 4: AI Ethics in Coaching
                                    PostPreview(
                                        authorName: "Prof. James Mitchell",
                                        spaceName: "Ethics & AI",
                                        createdAt: Date().addingTimeInterval(-259200), // 3 days ago
                                        avatarInitials: "JM",
                                        postTitle: "Navigating AI Ethics in Executive Coaching",
                                        postDescription: "Critical considerations for maintaining confidentiality and trust when incorporating AI tools into executive coaching practices.",
                                        postImageName: "image4", // Sequential image assignment
                                        likeCount: 15,
                                        commentCount: 3,
                                        isLiked: true,
                                        onLikeTapped: {
                                            print("Like tapped on AI ethics post!")
                                        },
                                        onCommentTapped: {
                                            print("Comment tapped on AI ethics post!")
                                        },
                                        onPostTapped: {
                                            print("Post tapped on AI ethics!")
                                        }
                                    )
                                    
                                    Divider()
                                    
                                    // Post 5: Success Story with AI Integration
                                    PostPreview(
                                        authorName: "Lisa Park",
                                        spaceName: "Success Stories",
                                        createdAt: Date().addingTimeInterval(-1800), // 30 minutes ago
                                        avatarImageName: "Avatar",
                                        postTitle: "Client Success: 40% Improvement in Decision-Making Speed",
                                        postDescription: "Sharing how we used AI-powered scenario planning to help a Fortune 500 CEO dramatically improve their strategic decision-making process.",
                                        postImageName: "image5", // Sequential image assignment
                                        likeCount: 89,
                                        commentCount: 12,
                                        isLiked: false,
                                        onLikeTapped: {
                                            print("Like tapped on success story post!")
                                        },
                                        onCommentTapped: {
                                            print("Comment tapped on success story post!")
                                        },
                                        onPostTapped: {
                                            print("Post tapped on success story!")
                                        }
                                    )
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .standardHorizontalPadding()
                        case "Video":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Video Content")
                                        .font(.headline)
                                )
                                .standardHorizontalPadding()
                        case "Courses":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Courses Content")
                                        .font(.headline)
                                )
                                .standardHorizontalPadding()
                        case "Events":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Events Content")
                                        .font(.headline)
                                )
                                .standardHorizontalPadding()
                        case "Members":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Members Content")
                                        .font(.headline)
                                )
                                .standardHorizontalPadding()
                        case "Leaderboard":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Leaderboard Content")
                                        .font(.headline)
                                )
                                .standardHorizontalPadding()
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitle("Community")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem() {
                    CreateMenu(
                        onCreatePost: { /* Create a post action */ },
                        onCreateImage: { /* Create an image action */ },
                        onGoLive: { /* Go live action */ },
                        onDrafts: { showDraftsSheet = true }
                    )
                }
                ToolbarSpacer()

                ToolbarItem(placement: .navigationBarTrailing) {
                    PrimaryMenu(
                        onProfile: { /* Add profile action here */ },
                        onNotifications: { /* Add notifications action here */ },
                        onSignOut: { /* Add sign out action here */ },
                        onSummarize: { /* Add summarize action here */ },
                        onSort: { sort in currentSort = sort },
                        currentSort: currentSort,
                        onSwitchCommunity: { /* Add switch community action here */ },
                        selectedTintColor: $selectedTintColor
                    )
                }
                .sharedBackgroundHidden()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .sheet(isPresented: $showDraftsSheet) {
            DraftsSheet()
        }
    }
}

#Preview {
    CommunityTab(selectedTintColor: .constant(Color.blue))
}
