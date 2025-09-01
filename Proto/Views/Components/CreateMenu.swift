//
//  CreateMenu.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct CreateMenu: View {
    let onCreatePost: () -> Void
    let onCreateImage: () -> Void
    let onGoLive: () -> Void
    let onDrafts: () -> Void
    
    var body: some View {
        Menu {
            Button(action: onCreatePost) {
                Text("Create a post")
            }
            
            Button(action: onCreateImage) {
                Text("Create an image")
            }
            
            Button(action: onGoLive) {
                Text("Go live")
            }
            
            Divider()
            
            Button(action: onDrafts) {
                Text("Drafts")
            }
        } label: {
            Image(systemName: "plus")
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    CreateMenu(
        onCreatePost: { print("Create post tapped") },
        onCreateImage: { print("Create image tapped") },
        onGoLive: { print("Go live tapped") },
        onDrafts: { print("Drafts tapped") }
    )
}
