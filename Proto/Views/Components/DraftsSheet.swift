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
                    
                    // Draft images - edge to edge with vertical scroll
                    VStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { index in
                            Button(action: {
                                // TODO: Open draft editor
                            }) {
                                Image("DraftDraft")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .clipped()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}


#Preview {
    DraftsSheet()
}
