//
//  ManageNotificationsSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct ManageNotificationsSheet: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Custom title
                Text("Manage Notifications")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                
                // Blank content area
                VStack(spacing: 16) {
                    // Placeholder for future content
                    Spacer(minLength: 100)
                    
                    Text("Notification management functionality")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .scrollIndicators(.hidden)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .presentationBackground(.ultraThinMaterial)
    }
}

#Preview {
    ManageNotificationsSheet()
}
