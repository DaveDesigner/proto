//
//  CommunityTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct CommunityTab: View {
    @State private var currentSort = "Latest"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Feed image scaled to fill width and fully scrollable
                    if let _ = UIImage(named: "Feed") {
                        NavigationLink(destination: PostDetails()) {
                            Image("Feed")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipped()
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
                        onDrafts: { /* Drafts action */ }
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

    }
}

#Preview {
    CommunityTab()
}
