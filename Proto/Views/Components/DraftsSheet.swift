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
                    
                    // Placeholder images grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        // Show your placeholder images
                        ForEach(0..<6, id: \.self) { index in
                            Button(action: {
                                // TODO: Open draft editor
                            }) {
                                VStack(spacing: 8) {
                                    Image("DraftDraft")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Draft \(index + 1)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}


#Preview {
    DraftsSheet()
}
