//
//  MessagesTab.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessagesTab: View {
    @State private var selectedSegment = 0
    @Binding var selectedTintColor: Color
    
    private let messageSegments = ["Inbox", "Agents"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Segment control for content switching
                    SegmentControl(
                        segments: messageSegments,
                        selectedIndex: $selectedSegment,
                        onSelectionChanged: { index in
                            selectedSegment = index
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Content based on selected segment
                    Group {
                        switch messageSegments[selectedSegment] {
                        case "Inbox":
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
                                        Text("Inbox Messages")
                                            .font(.headline)
                                    )
                                    .padding(.horizontal)
                            }
                        case "Agents":
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .frame(height: 300)
                                .overlay(
                                    Text("Agents Content")
                                        .font(.headline)
                                )
                                .padding(.horizontal)
                        default:
                            EmptyView()
                        }
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
                        onSignOut: { /* Add sign out action here */ },
                        selectedTintColor: $selectedTintColor
                    )
                }
            }
        }
    }
}

#Preview {
    MessagesTab(selectedTintColor: .constant(Color.blue))
}
