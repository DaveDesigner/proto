//
//  SwitchCommunitySheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SwitchCommunitySheet: View {
    var body: some View {
        SheetTemplate(title: "Switch Community") {
            // Blank content area
            VStack(spacing: 16) {
                // Placeholder for future content
                Spacer(minLength: 100)
                
                Text("Community switching functionality")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SwitchCommunitySheet()
}
