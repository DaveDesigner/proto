//
//  PostSettingsSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PostSettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    // Settings state
    @State private var publishTimestamp = "May 27, 2025 11:42 AM"
    @State private var customHTML = "<iframe src=\"https://davedesigner.github.io/way-of-code/empty-inexhaustible.html\" width=\"550\" height=\"550\" frameborder=\"0\"></iframe>"
    @State private var space = "The Way of Code"
    @State private var customURLSlug = "empty-yet-inexhaustible"
    @State private var author = "Dave Morgan"
    @State private var metaTitle = ""
    @State private var metaDescription = ""
    @State private var openGraphTitle = ""
    @State private var openGraphDescription = ""
    
    // Post visibility and behavior toggles
    @State private var hideMetaInfo = false
    @State private var hideComments = false
    @State private var closeComments = false
    @State private var hideLikes = false
    @State private var disableTruncation = false
    @State private var pinPostToTop = false
    @State private var hideFromFeaturedAreas = false
    
    // Save functionality
    @State private var hasUnsavedChanges = false
    @State private var isSaving = false
    
    var body: some View {
        SheetTemplate(title: "Settings") {
            VStack(spacing: 24) {
                // Post visibility and behavior toggles
                    SettingsToggleRow(
                        title: "Hide meta info",
                        isOn: $hideMetaInfo
                    )
                    
                    SettingsToggleRow(
                        title: "Hide comments",
                        isOn: $hideComments
                    )
                    
                    SettingsToggleRow(
                        title: "Close comments",
                        isOn: $closeComments
                    )
                    
                    SettingsToggleRow(
                        title: "Hide likes",
                        isOn: $hideLikes
                    )
                    
                    SettingsToggleRow(
                        title: "Disable truncation",
                        isOn: $disableTruncation
                    )
                    
                    SettingsToggleRow(
                        title: "Pin post to top",
                        isOn: $pinPostToTop
                    )
                    
                    SettingsToggleRow(
                        title: "Hide from featured areas",
                        isOn: $hideFromFeaturedAreas
                    )
                
                // Publish timestamp
                SettingsInputField(
                    title: "Publish timestamp",
                    text: $publishTimestamp
                )
                
                // Custom HTML
                SettingsInputField(
                    title: "Custom HTML",
                    text: $customHTML,
                    isMultiline: true,
                    helpText: "Add custom HTML below the post. Please note: This is an advanced feature and intended for developers only. Unfortunately, our support team cannot help you with custom HTML code."
                )
                
                // Space
                SettingsInputField(
                    title: "Space",
                    text: $space,
                    hasDropdown: true
                )
                
                // Custom URL slug
                SettingsInputField(
                    title: "Custom URL slug",
                    text: $customURLSlug
                )
                
                // Author
                SettingsInputField(
                    title: "Author",
                    text: $author
                )
                
                // Meta title
                SettingsInputField(
                    title: "Meta title",
                    text: $metaTitle,
                    helpText: "Customize the title meta tag for SEO. If empty, we'll use the name of the post."
                )
                
                // Meta description
                SettingsInputField(
                    title: "Meta description",
                    text: $metaDescription,
                    helpText: "Customize the description meta tag for SEO."
                )
                
                // Open Graph title
                SettingsInputField(
                    title: "Open Graph title",
                    text: $openGraphTitle,
                    helpText: "Customize the Open Graph title. If empty, we'll use the post name."
                )
                
                // Open Graph description
                SettingsInputField(
                    title: "Open Graph description",
                    text: $openGraphDescription,
                    helpText: "Customize the Open Graph description."
                )
                
                // Open Graph image
                OpenGraphImageSection()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    
                    Button("Save") {
                        saveSettings()
                    }
                    .disabled(!hasUnsavedChanges || isSaving)
                }
                .sharedBackgroundVisible()
            }
        }
        .onChange(of: publishTimestamp) { _, _ in hasUnsavedChanges = true }
        .onChange(of: customHTML) { _, _ in hasUnsavedChanges = true }
        .onChange(of: space) { _, _ in hasUnsavedChanges = true }
        .onChange(of: customURLSlug) { _, _ in hasUnsavedChanges = true }
        .onChange(of: author) { _, _ in hasUnsavedChanges = true }
        .onChange(of: metaTitle) { _, _ in hasUnsavedChanges = true }
        .onChange(of: metaDescription) { _, _ in hasUnsavedChanges = true }
        .onChange(of: openGraphTitle) { _, _ in hasUnsavedChanges = true }
        .onChange(of: openGraphDescription) { _, _ in hasUnsavedChanges = true }
        .onChange(of: hideMetaInfo) { _, _ in hasUnsavedChanges = true }
        .onChange(of: hideComments) { _, _ in hasUnsavedChanges = true }
        .onChange(of: closeComments) { _, _ in hasUnsavedChanges = true }
        .onChange(of: hideLikes) { _, _ in hasUnsavedChanges = true }
        .onChange(of: disableTruncation) { _, _ in hasUnsavedChanges = true }
        .onChange(of: pinPostToTop) { _, _ in hasUnsavedChanges = true }
        .onChange(of: hideFromFeaturedAreas) { _, _ in hasUnsavedChanges = true }
    }
    
    private func saveSettings() {
        isSaving = true
        
        // Simulate save operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSaving = false
            hasUnsavedChanges = false
            // Here you would typically save to your data model or API
        }
    }
}

struct SettingsInputField: View {
    let title: String
    @Binding var text: String
    var isMultiline: Bool = false
    var hasClearButton: Bool = false
    var hasDropdown: Bool = false
    var helpText: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            
            HStack {
                if isMultiline {
                    TextEditor(text: $text)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.primary)
                        .frame(minHeight: 120) // Increased height to show ~5 lines
                        .scrollContentBackground(.hidden)
                } else {
                    TextField("", text: $text)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.primary)
                }
                
                if hasClearButton {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(width: 20, height: 20)
                    }
                }
                
                if hasDropdown {
                    Button(action: {
                        // Handle dropdown action
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color(red: 173/255, green: 184/255, blue: 194/255, opacity: 0.2))
            .cornerRadius(16)
            
            if let helpText = helpText {
                Text(helpText)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct OpenGraphImageSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Open Graph image (Optional)")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.secondary)
            
            HStack {
                // Placeholder for image
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 100)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.gray)
                    )
                
                Button(action: {
                    // Handle edit action
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

#Preview {
    PostSettingsSheet()
}
