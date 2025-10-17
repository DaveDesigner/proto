//
//  EditProfileSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// A sheet for editing user profile information
/// Uses SheetTemplate for consistent iOS 26 presentation with Liquid Glass effect

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = "Kemi Bello"
    @State private var headline = "Experienced Digital Marketing Strategist Passionate About Leveraging Data Analytics and AI to Transform Brand Engagement and Drive Conversion | Speaker, Mentor, and Industry Thought Leader"
    @State private var email = "kemi.bello@mail.com"
    @State private var location = "San Francisco"
    @State private var bio = "This bio field is styled differently from other custom fields, positioned above the fold and centre aligned."
    @State private var customField1 = "Content of custom field higher priority than label, so given primary text treatment"
    @State private var customField2 = "Content of custom field higher priority than label, so given primary text treatment"
    @State private var hasChanges = false

    var body: some View {
        SheetTemplate(
            title: "Edit Profile",
            detents: [.large],
            primaryAction: .init(
                title: "Save",
                action: {
                    saveProfile()
                    dismiss()
                },
                isDisabled: { !hasChanges }
            ),
            secondaryAction: .init(
                title: "Cancel",
                action: { dismiss() }
            )
        ) {
            VStack(spacing: 24) {
                // Avatar section (placeholder)
                avatarSection

                // Form fields
                VStack(spacing: 20) {
                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: name) { _, _ in hasChanges = true }
                    }

                    // Headline
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Headline")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Headline", text: $headline, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...5)
                            .onChange(of: headline) { _, _ in hasChanges = true }
                    }

                    Divider()

                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: email) { _, _ in hasChanges = true }
                    }

                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Location", text: $location)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: location) { _, _ in hasChanges = true }
                    }

                    Divider()

                    // Bio
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Bio", text: $bio, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...5)
                            .onChange(of: bio) { _, _ in hasChanges = true }
                    }

                    // Custom fields
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom Field 1")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Custom field content", text: $customField1, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                            .onChange(of: customField1) { _, _ in hasChanges = true }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom Field 2")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                        TextField("Custom field content", text: $customField2, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                            .onChange(of: customField2) { _, _ in hasChanges = true }
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: 12) {
            // Avatar with edit overlay
            ZStack(alignment: .bottomTrailing) {
                Image("Avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())

                // Edit button
                Button(action: { /* Change avatar */ }) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.primary)
                        .clipShape(Circle())
                }
                .offset(x: -4, y: -4)
            }

            Text("Tap to change photo")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Save Profile
    private func saveProfile() {
        print("Saving profile...")
        print("Name: \(name)")
        print("Email: \(email)")
        // TODO: Implement actual save logic
    }
}

// MARK: - Preview
#Preview {
    EditProfileSheet()
}

#Preview("Dark Mode") {
    EditProfileSheet()
        .preferredColorScheme(.dark)
}
