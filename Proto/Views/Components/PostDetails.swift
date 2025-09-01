//
//  PostDetails.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PostDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Post image scaled to fill width and fully scrollable
                    if let _ = UIImage(named: "Post") {
                        Image("Post")
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
                                Text("Post Image")
                                    .font(.headline)
                            )
                            .padding(.horizontal)
                    }   
                }
            }

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(action: {}) {
                            Label("Summarize", systemImage: "sparkle")
                                .tint(Color(hex: "#9676F8"))
                        }
                        
                        Divider()
                        
                        Button(action: {}) {
                            Label("23 likes", systemImage: "heart")
                        }
                        
                        Button(action: {}) {
                            Label("11 comments", systemImage: "message")
                        }
                        
                        Divider()
                        
                        Button(action: {}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(action: {}) {
                            Label("Bookmark", systemImage: "bookmark")
                        }
                        
                        Button(action: {}) {
                            Label("Follow", systemImage: "bell")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                        .font(.title2)
                        .foregroundColor(.primary)
                    Spacer(minLength: 16)
                    TextField("Add a comment", text: .constant(""))
                        .textFieldStyle(.plain)
                    Spacer(minLength: 16)
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    PostDetails()
}
