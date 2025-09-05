//
//  SwitchCommunitySheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SwitchCommunitySheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SheetTemplate(title: "Switch Community") {
            VStack(spacing: 16) {
                Spacer(minLength: 100)
                
                Text("Community switching functionality")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                
                Button("Switch to Community Color") {
                    // TODO: Implement community color switching
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Spacer(minLength: 100)
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SwitchCommunitySheet()
}
