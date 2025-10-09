//
//  InviteMembersSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct InviteMembersSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        SheetTemplate(title: "Invite Members") {
            VStack(spacing: 24) {
                // TODO: Implement invite members functionality
                Text("Invite Members functionality will be implemented here")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

#Preview {
    InviteMembersSheet()
}
