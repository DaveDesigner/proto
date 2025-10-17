//
//  ProfileView.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// A member profile view that displays user information, badges, and content.
/// When viewing own profile, shows "Edit Profile" button. When viewing others, shows "Message" button.
///
/// Features:
/// - Adaptive button (Edit Profile vs Message based on isOwnProfile)
/// - Profile header with avatar (progress ring placeholder for future)
/// - Member tags/badges with pill components
/// - Custom fields section
/// - Content stats (Posts, Comments, Spaces)
/// - Glassmorphic toolbar using iOS 26 native APIs

struct ProfileView: View {
    let isOwnProfile: Bool
    @State private var showingEditProfile = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                profileHeader

                // Name & Headline
                nameAndHeadline

                // Primary Action Button (Edit Profile or Message)
                primaryActionButton

                // Contact Info
                contactInfo

                // Member Badges
                memberBadges

                // Bio / Custom Fields
                customFieldsSection

                // Content Section
                contentSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 100)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if isOwnProfile {
                        Button(action: { /* Share profile */ }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    } else {
                        Button(action: { /* Connect */ }) {
                            Label("Connect", systemImage: "plus")
                        }
                        Button(action: { /* View as username */ }) {
                            Label("View as Kemi Bello", systemImage: "eye")
                        }
                        Button(action: { /* Share */ }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.body.weight(.medium))
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileSheet()
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 0) {
            // Avatar (placeholder - progress ring will be added later)
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 176, height: 176)

                Image("Avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipShape(Circle())

                // Leaderboard badge (placeholder)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("7")
                                    .font(.body.weight(.bold))
                                    .foregroundColor(.purple)
                            )
                            .offset(x: -8, y: -8)
                    }
                }
                .frame(width: 176, height: 176)
            }
        }
    }

    // MARK: - Name & Headline
    private var nameAndHeadline: some View {
        VStack(spacing: 4) {
            Text("Kemi Bello")
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            Text("Experienced Digital Marketing Strategist Passionate About Leveraging Data Analytics and AI to Transform Brand Engagement and Drive Conversion | Speaker, Mentor, and Industry Thought Leader")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Primary Action Button
    private var primaryActionButton: some View {
        Group {
            if isOwnProfile {
                ProtoButton("Edit Profile", style: .secondary) {
                    showingEditProfile = true
                }
            } else {
                ProtoButton("Message", style: .primary) {
                    // Navigate to messages
                    print("Message tapped")
                }
            }
        }
    }

    // MARK: - Contact Info
    private var contactInfo: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "envelope")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("kemi.bello@mail.com")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                Image(systemName: "location")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("San Francisco")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Member Badges
    private var memberBadges: some View {
        FlowLayout(spacing: 8) {
            Pill("Circle Affiliate")
            Pill("Circle Team")
            Pill("Speaker", emoji: "🔥")
            Pill("Storyteller", emoji: "⛺️")
            Pill("Designer", emoji: "🖌️")
        }
    }

    // MARK: - Custom Fields Section
    private var customFieldsSection: some View {
        VStack(spacing: 16) {
            // Bio field (special styling, center-aligned)
            VStack(alignment: .leading, spacing: 8) {
                Text("This bio field is styled differently from other custom fields, positioned above the fold and centre aligned. Though could be pushed down below. Use cases seem to be plans that don't include custom fields, at which point bio would be displayed like those others with label and left aligned.")
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // Custom field with label
            VStack(alignment: .leading, spacing: 4) {
                Text("Custom field label")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("Content of custom field higher priority than label, so given primary text treatment")
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // Another custom field
            VStack(alignment: .leading, spacing: 4) {
                Text("Custom field label")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("Content of custom field higher priority than label, so given primary text treatment")
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CONTENT")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)

            // Posts
            HStack {
                Text("Posts")
                    .font(.body)
                    .foregroundStyle(.primary)
                Spacer()
                Text("7")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Divider()

            // Comments
            HStack {
                Text("Comments")
                    .font(.body)
                    .foregroundStyle(.primary)
                Spacer()
                Text("9")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }

            Divider()

            // Spaces
            HStack {
                Text("Spaces")
                    .font(.body)
                    .foregroundStyle(.primary)
                Spacer()
                Text("30")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Preview
#Preview("Own Profile") {
    NavigationStack {
        ProfileView(isOwnProfile: true)
    }
}

#Preview("Other User Profile") {
    NavigationStack {
        ProfileView(isOwnProfile: false)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        ProfileView(isOwnProfile: true)
    }
    .preferredColorScheme(.dark)
}
