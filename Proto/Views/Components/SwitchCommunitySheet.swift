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
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                // Placeholder for Figma component
                VStack(spacing: 16) {
                    Text("Community Color Options")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Figma component will go here")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                
                // Close button
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SwitchCommunitySheet(selectedTintColor: .constant(Color.blue))
}
