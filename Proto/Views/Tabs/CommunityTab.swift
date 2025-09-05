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
    
    private let communitySegments = ["Feed", "Video", "Courses", "Events", "Members", "Leaderboard"]
    
    private var feedBlendMode: BlendMode {
        colorScheme == .dark ? .screen : .multiply
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Segment control for content switching
                    SegmentControl(
                        segments: communitySegments,
                        selectedIndex: $selectedSegment,
                        onSelectionChanged: { index in
                            selectedSegment = index
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch communitySegments[selectedSegment] {
                        case "Feed":
                            // Feed image scaled to fill width and fully scrollable
                            if let _ = UIImage(named: "Feed") {
                                NavigationLink(destination: PostDetails()) {
                                    Image("Feed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .blendMode(feedBlendMode)
                                }
                            } else {
                                // Fallback if image not found
                                NavigationLink(destination: PostDetails()) {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                        .frame(height: 400)
                                        .overlay(
                                            Text("Feed Image")
                                                .font(.headline)
                                        )
                                        .padding(.horizontal)
                                }
                            }
                        case "Video":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Video Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Courses":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Courses Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Events":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Events Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Members":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Members Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        case "Leaderboard":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Leaderboard Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        default:
                            EmptyView()
                        }
                    }
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
                        onSwitchCommunity: { /* Add switch community action here */ }
                    )
                }
            }
        }
        .sheet(isPresented: $showDraftsSheet) {
            DraftsSheet()
        }
    }
}

#Preview {
    CommunityTab()
}
