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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Search View")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .padding(.vertical, 16)
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                //ToolbarSpacer(.fixed)

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
            .searchable(text: $searchText)
            .searchToolbarBehavior(.automatic)
        }
    }
}

#Preview {
    SearchTab(selectedTintColor: .constant(Color.blue))
}
