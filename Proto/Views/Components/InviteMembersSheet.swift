//
//  InviteMembersSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct InviteMembersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isEmailFieldFocused: Bool
    @State private var emailText = ""
    @State private var notifyInEmail = true
    @State private var giveAdminPrivileges = false
    @State private var showMemberTagsSheet = false
    @State private var selectedTags: [String] = []
    @State private var isSending = false
    
    private let availableTags = ["Designer", "Developer", "Manager", "Marketing", "Sales", "Support"]
    
    var body: some View {
        SheetTemplate(title: "Invite members") {
            VStack(spacing: 0) {
                // Email input section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    TextField("Enter email…", text: $emailText)
                        .focused($isEmailFieldFocused)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.primary)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(Color(red: 173/255, green: 184/255, blue: 194/255, opacity: 0.2))
                        .cornerRadius(16)
                    
                    Text("Separate multiple emails with commas.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.tertiary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                // Toggle options
                VStack(spacing: 0) {
                    // Notify in email toggle
                    HStack {
                        Text("Notify in an email")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $notifyInEmail)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Give admin privileges toggle
                    HStack {
                        Text("Give admin privileges")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $giveAdminPrivileges)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Member tags button
                    Button(action: {
                        showMemberTagsSheet = true
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Member tags")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.primary)
                                Text("Tap to add tags")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.tertiary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") {
                        sendInvite()
                    }
                    .disabled(emailText.isEmpty || isSending)
                }
                .sharedBackgroundVisible()
            }
        }
        .onAppear {
            // Auto-focus the email field when sheet appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isEmailFieldFocused = true
            }
        }
        .sheet(isPresented: $showMemberTagsSheet) {
            MemberTagsSheet(selectedTags: $selectedTags, availableTags: availableTags)
        }
    }
    
    private func sendInvite() {
        guard !emailText.isEmpty else { return }
        
        isSending = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSending = false
            dismiss()
        }
    }
}

// Member Tags Sheet
struct MemberTagsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTags: [String]
    let availableTags: [String]
    
    var body: some View {
        SheetTemplate(title: "Member tags") {
            VStack(spacing: 16) {
                // Selected tags display
                if !selectedTags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Tags")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                            ForEach(selectedTags, id: \.self) { tag in
                                HStack(spacing: 4) {
                                    Text(tag)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                    
                                    Button(action: {
                                        selectedTags.removeAll { $0 == tag }
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.quaternary, in: Capsule())
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
                
                // Available tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("Available Tags")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                        ForEach(availableTags, id: \.self) { tag in
                            Button(action: {
                                if selectedTags.contains(tag) {
                                    selectedTags.removeAll { $0 == tag }
                                } else {
                                    selectedTags.append(tag)
                                }
                            }) {
                                Text(tag)
                                    .font(.caption)
                                    .foregroundColor(selectedTags.contains(tag) ? .white : .primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        selectedTags.contains(tag) ? .blue : .quaternary,
                                        in: Capsule()
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
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
