//
//  DraftsSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct DraftsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        SheetTemplate(title: "Drafts") {
            // Draft list items
            VStack(spacing: 0) {
                DraftItem(
                    title: "Discovering My Vietnamese Heritage: A Journey to Vietnam and Passing Down the Family Pho Recipe to all",
                    authorName: "Dave Morgan",
                    timeAgo: "1h ago",
                    initials: "DM"
                )
                                        
                DraftItem(
                    title: "Testing test",
                    authorName: "Kemi Adeola",
                    timeAgo: "2h ago",
                    initials: nil
                )
                
                DraftItem(
                    title: "Draft post",
                    authorName: "Kemi Adeola",
                    timeAgo: "1d ago",
                    initials: nil
                )
                
                DraftItem(
                    title: "Draft post",
                    authorName: "Dave Morgan",
                    timeAgo: "Aug 22",
                    initials: "DM"
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

struct DraftItem: View {
    let title: String
    let authorName: String
    let timeAgo: String
    let initials: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Avatar(initials: initials, size: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(authorName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(timeAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    DraftsSheet()
}
