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
                        PostListItem(
                            title: "Discovering My Vietnamese Heritage: A Journey to Vietnam and Passing Down the Family Pho Recipe to all",
                            authorName: "Dave Morgan",
                            timeAgo: "1h ago",
                            initials: "DM"
                        )
                                                
                        PostListItem(
                            title: "Testing test",
                            authorName: "Kemi Adeola",
                            timeAgo: "2h ago",
                            initials: nil
                        )
                        
                        PostListItem(
                            title: "Draft post",
                            authorName: "Kemi Adeola",
                            timeAgo: "1d ago",
                            initials: nil
                        )
                        
                        PostListItem(
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



#Preview {
    DraftsSheet()
}
