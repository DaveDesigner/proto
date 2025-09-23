//
//  SearchTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SearchTab: View {
    @Binding var selectedTintColor: Color
    @State private var searchText = ""
    @State private var recentSearches = [
        "Fun camping ideas",
        "iOS development tips",
        "Design system components",
        "SwiftUI tutorials"
    ]
    private var isSearching: Bool {
        !searchText.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if isSearching {
                        // Search results or candidates
                        searchResultsView
                    } else {
                        // Empty state with recent searches
                        emptyStateView
                    }
                }
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ProfileMenu(
                        onProfile: { /* Add profile action here */ },
                        onNotifications: { /* Add notifications action here */ },
                        onSignOut: { /* Add sign out action here */ },
                        selectedTintColor: $selectedTintColor
                    )
                }
                .sharedBackgroundHidden()
            }
            .searchable(text: $searchText, prompt: "Search")
            .searchToolbarBehavior(.automatic)
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            // Recent searches section
            if !recentSearches.isEmpty {
                VStack(spacing: 0) {
                    // Section header
                    VStack(spacing: 4) {
                        Text("Recent searches")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.quaternary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    // Recent searches list
                    LazyVStack(spacing: 24) {
                        ForEach(Array(recentSearches.enumerated()), id: \.offset) { index, search in
                            RecentSearchItem(
                                searchText: search,
                                onTap: {
                                    searchText = search
                                },
                                onRemove: {
                                    removeRecentSearch(at: index)
                                }
                            )
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
            } else {
                // Only show empty state if no recent searches
                VStack(spacing: 16) {
                    // Search icon
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundColor(.secondary)
                        .padding(.top, 150)
                    
                    // Description text
                    Text("Search for spaces, posts, comments, and members.")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
            
            Spacer(minLength: 100)
        }
    }
    
    // MARK: - Search Results View
    private var searchResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.secondary)
                .padding(.top, 100)
            
            Text("No results found for \"\(searchText)\"")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Helper Methods
    private func addRecentSearch(_ search: String) {
        // Remove if already exists
        recentSearches.removeAll { $0 == search }
        
        // Add to beginning
        recentSearches.insert(search, at: 0)
        
        // Keep only last 10
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
    }
    
    private func removeRecentSearch(at index: Int) {
        guard index < recentSearches.count else { return }
        recentSearches.remove(at: index)
    }
}

#Preview {
    SearchTab(selectedTintColor: .constant(Color.blue))
}
