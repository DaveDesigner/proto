//
//  AdminSettingsSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct AdminSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Custom title
                Text("Admin settings")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                
                // Menu items
                VStack(spacing: 0) {
                    // View as
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "eye")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("View as")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    
                    // Invite members
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("Invite members")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    
                    // Member management
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "person.2")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("Member management")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Copilot
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "sparkle")
                                .foregroundColor(Color(hex: "#9676F8"))
                                .frame(width: 28, height: 28)
                            Text("Copilot")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    
                    // AI Inbox
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "tray")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("AI Inbox")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Push notification
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "app.badge")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("Push notification")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Drafts
                    Button(action: {}) {
                        HStack(spacing: 16) {
                            Image(systemName: "doc.text")
                                .foregroundColor(.secondary)
                                .frame(width: 28, height: 28)
                            Text("Drafts")
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .scrollIndicators(.hidden)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .presentationBackground(.ultraThinMaterial)
    }
}

// Extension to support hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
        }
    }

#Preview {
    AdminSettingsSheet()
}
