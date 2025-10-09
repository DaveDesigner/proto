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
    
    private var sendAction: SheetAction {
        SheetAction(
            title: "Send",
            action: { sendInvite() },
            isDisabled: { emailText.isEmpty || isSending }
        )
    }
    
    var body: some View {
        SheetTemplate(
            title: "Invite members",
            primaryAction: sendAction
        ) {
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
                            .toggleStyle(SwitchToggleStyle(tint: .primary))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Give admin privileges toggle
                    HStack {
                        Text("Give admin privileges")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.primary)
                        Spacer()
                        Toggle("", isOn: $giveAdminPrivileges)
                            .toggleStyle(SwitchToggleStyle(tint: .primary))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Member tags button
                    Button(action: {
showMemberTagsSheet = true
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Member tags")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.primary)
                                Text(selectedTags.isEmpty ? "Tap to add tags" : selectedTags.joined(separator: ", "))
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.tertiary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
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
            VStack(spacing: 0) {
                // Available tags as list items
                ForEach(availableTags, id: \.self) { tag in
                    Button(action: {
                        if selectedTags.contains(tag) {
                            selectedTags.removeAll { $0 == tag }
                        } else {
                            selectedTags.append(tag)
                        }
                    }) {
                        HStack {
                            Text(tag)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedTags.contains(tag) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }
}

#Preview {
    InviteMembersSheet()
}
