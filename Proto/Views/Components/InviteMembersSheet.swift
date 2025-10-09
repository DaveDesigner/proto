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
        SheetTemplate(
            title: "Invite members",
            topRightAction: {
                AnyView(
                    Button(action: sendInvite) {
                        Text("Send")
                            .font(.body.weight(.medium))
                            .foregroundColor(emailText.isEmpty ? .secondary : .blue)
                    }
                    .disabled(emailText.isEmpty || isSending)
                )
            }
        ) {
            VStack(spacing: 24) {
                // Email input section with glass effect
                VStack(alignment: .leading, spacing: 8) {
                    // Glass effect input field
                    ZStack {
                        // Glass effect background
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.quaternary, lineWidth: 0.5)
                            )
                        
                        HStack {
                            // Text cursor simulation
                            if isEmailFieldFocused {
                                Rectangle()
                                    .fill(.primary)
                                    .frame(width: 2, height: 20)
                                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isEmailFieldFocused)
                            }
                            
                            TextField("Enter email…", text: $emailText)
                                .focused($isEmailFieldFocused)
                                .textFieldStyle(.plain)
                                .font(.body)
                                .foregroundColor(.primary)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    }
                    .frame(height: 50)
                    
                    // Helper text
                    Text("Separate multiple emails with commas.")
                        .font(.caption)
                        .foregroundColor(.tertiary)
                }
                
                // Toggle options
                VStack(spacing: 0) {
                    // Notify in email toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Notify in an email")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Toggle("", isOn: $notifyInEmail)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .padding(.vertical, 16)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Give admin privileges toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Give admin privileges")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        Toggle("", isOn: $giveAdminPrivileges)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
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
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Text("Tap to add tags")
                                    .font(.caption)
                                    .foregroundColor(.tertiary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.tertiary)
                        }
                        .padding(.vertical, 16)
                    }
                    .buttonStyle(.plain)
                }
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
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
