//
//  MessagesTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessagesTab: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Messages image scaled to fill width and fully scrollable
                    if let _ = UIImage(named: "Messages") {
                        Image("Messages")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else {
                        // Fallback if image not found
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .frame(height: 400)
                            .overlay(
                                Text("Messages Image")
                                    .font(.headline)
                            )
                            .padding(.horizontal)
                    }   
                }
            }
            .navigationBarTitle("Messages")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem() {
                    Button(action: {
                        // Create new message action
                    }) {
                        Image(systemName: "plus")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarSpacer()

                ToolbarItem(placement: .navigationBarTrailing) {
                    ProfileMenu(
                        onProfile: { /* Add profile action here */ },
                        onNotifications: { /* Add notifications action here */ },
                        onSignOut: { /* Add sign out action here */ }
                    )
                }
            }
        }
    }
}

#Preview {
    MessagesTab()
}
