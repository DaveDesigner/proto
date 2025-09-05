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
    
    // Sample draft data
    private let drafts = [
        DraftItem(
            id: "1",
            title: "Community Guidelines Update",
            preview: "We're updating our community guidelines to better reflect our values...",
            lastModified: Date().addingTimeInterval(-3600), // 1 hour ago
            isPublished: false
        ),
        DraftItem(
            id: "2", 
            title: "New Feature Announcement",
            preview: "Exciting news! We're launching a new feature that will...",
            lastModified: Date().addingTimeInterval(-7200), // 2 hours ago
            isPublished: false
        ),
        DraftItem(
            id: "3",
            title: "Weekly Community Roundup",
            preview: "Here's what happened in our community this week...",
            lastModified: Date().addingTimeInterval(-86400), // 1 day ago
            isPublished: false
        ),
        DraftItem(
            id: "4",
            title: "Welcome New Members",
            preview: "A warm welcome to all our new community members...",
            lastModified: Date().addingTimeInterval(-172800), // 2 days ago
            isPublished: true
        )
    ]
    
    var body: some View {
        SheetTemplate {
            ScrollView {
                VStack(spacing: 0) {
                    // Custom title
                    Text("Drafts")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    // Drafts list
                    LazyVStack(spacing: 0) {
                        ForEach(drafts) { draft in
                            DraftRowView(draft: draft, colorScheme: colorScheme)
                            
                            if draft.id != drafts.last?.id {
                                Divider()
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}

struct DraftItem: Identifiable {
    let id: String
    let title: String
    let preview: String
    let lastModified: Date
    let isPublished: Bool
}

struct DraftRowView: View {
    let draft: DraftItem
    let colorScheme: ColorScheme
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: draft.lastModified, relativeTo: Date())
    }
    
    var body: some View {
        Button(action: {
            // TODO: Open draft editor
        }) {
            HStack(spacing: 16) {
                // Draft icon with light/dark mode support
                Image(draft.isPublished ? "DraftPublished" : "DraftDraft")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundColor(draft.isPublished ? .green : .secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(draft.title)
                            .font(.body.weight(.medium))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if draft.isPublished {
                            Text("Published")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(draft.preview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(timeAgo)
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DraftsSheet()
}
