//
//  AdminSettingsSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct AdminSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showDraftsSheet = false
    
    var body: some View {
        SheetTemplate(title: "Admin settings") {
            VStack(spacing: 0) {
                
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
                                .foregroundColor(Color(red: 150/255, green: 118/255, blue: 248/255))
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
                    Button(action: {
                        showDraftsSheet = true
                    }) {
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
        .sheet(isPresented: $showDraftsSheet) {
            DraftsSheet()
        }
    }
}
#Preview {
    AdminSettingsSheet()
}
