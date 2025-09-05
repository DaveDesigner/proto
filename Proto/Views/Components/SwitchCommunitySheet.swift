//
//  SwitchCommunitySheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SwitchCommunitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTintColor: Color
    
    var body: some View {
        SheetTemplate(title: "Switch Community") {
            VStack(spacing: 16) {
                Spacer(minLength: 100)
                
                Text("Community switching functionality")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                
                Button("Switch to Community Color") {
                    // Generate a new random color for the community
                    selectedTintColor = Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
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
    SwitchCommunitySheet(selectedTintColor: .constant(Color.blue))
}
