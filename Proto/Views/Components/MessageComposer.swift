//
//  MessageComposer.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessageComposer: View {
    @Binding var text: AttributedString
    @Binding var selection: AttributedTextSelection
    @FocusState.Binding var isFocused: Bool
    @State private var isHeartFilled = false

    var placeholder: String = "Add message"
    var onSubmit: (() -> Void)?
    var onDragStart: (() -> Void)?

    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            // Text editor with AttributedString and selection support (iOS 26+)
            TextEditor(text: $text, selection: $selection)
                .font(.body)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .fixedSize(horizontal: false, vertical: true)
            
            // Submit button with glass effect
            Button(action: {
                onSubmit?()
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            .disabled(text.characters.isEmpty)
            .opacity(text.characters.isEmpty ? 0.5 : 1.0)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .simultaneousGesture(
            DragGesture(minimumDistance: 10)
                .onChanged { _ in
                    onDragStart?()
                }
        )
    }
}

// MARK: - Formatting Helper Functions
struct TextFormattingHelper {
    /// Gets the current selection range or cursor position
    static func getCurrentRange(for text: AttributedString, selectedRange: Range<AttributedString.Index>?) -> Range<AttributedString.Index>? {
        // Return the provided selected range if it exists and is not empty
        if let selectedRange = selectedRange, !selectedRange.isEmpty {
            return selectedRange
        }
        
        // If no selection is provided, return nil
        // This will cause the formatting functions to add new formatted text instead
        // Note: SwiftUI's TextEditor doesn't provide direct access to text selection
        // For now, formatting will add new text when no selection is manually provided
        return nil
    }
    
    /// Checks if the selected text has bold formatting
    static func isBoldFormatted(in text: AttributedString, range: Range<AttributedString.Index>) -> Bool {
        let substring = text[range]
        for run in substring.runs {
            if let font = run.font {
                // Check if the font has bold weight by creating a bold font and comparing
                let boldFont = Font.system(size: 17, weight: .bold, design: .default)
                // For now, we'll use a simple approach - check if the font was created with bold weight
                // This is a simplified check and may not work in all cases
                return font == boldFont
            }
        }
        return false
    }
    
    /// Checks if the selected text has italic formatting
    static func isItalicFormatted(in text: AttributedString, range: Range<AttributedString.Index>) -> Bool {
        let substring = text[range]
        for run in substring.runs {
            if let font = run.font {
                // Check if the font is italic by creating an italic font and comparing
                let italicFont = Font.system(size: 17, weight: .regular, design: .default).italic()
                // For now, we'll use a simple approach - check if the font was created with italic
                // This is a simplified check and may not work in all cases
                return font == italicFont
            }
        }
        return false
    }
    
    /// Checks if the selected text has underline formatting
    static func isUnderlineFormatted(in text: AttributedString, range: Range<AttributedString.Index>) -> Bool {
        let substring = text[range]
        for run in substring.runs {
            if run.underlineStyle == .single {
                return true
            }
        }
        return false
    }
    
    /// Checks if the selected text has strikethrough formatting
    static func isStrikethroughFormatted(in text: AttributedString, range: Range<AttributedString.Index>) -> Bool {
        let substring = text[range]
        for run in substring.runs {
            if run.strikethroughStyle == .single {
                return true
            }
        }
        return false
    }
    
    /// Toggles bold formatting on the selected text
    static func toggleBold(text: inout AttributedString, selectedRange: Range<AttributedString.Index>?) {
        guard let range = getCurrentRange(for: text, selectedRange: selectedRange), !range.isEmpty else {
            // If no selection, add bold text
            var boldText = AttributedString("bold text")
            boldText.font = .system(size: 17, weight: .bold, design: .default)
            text.append(AttributedString(" "))
            text.append(boldText)
            return
        }
        
        if isBoldFormatted(in: text, range: range) {
            // Remove bold formatting
            text[range].font = .system(size: 17, weight: .regular, design: .default)
        } else {
            // Apply bold formatting
            text[range].font = .system(size: 17, weight: .bold, design: .default)
        }
    }
    
    /// Toggles italic formatting on the selected text
    static func toggleItalic(text: inout AttributedString, selectedRange: Range<AttributedString.Index>?) {
        guard let range = getCurrentRange(for: text, selectedRange: selectedRange), !range.isEmpty else {
            // If no selection, add italic text
            var italicText = AttributedString("italic text")
            italicText.font = .system(size: 17, weight: .regular, design: .default).italic()
            text.append(AttributedString(" "))
            text.append(italicText)
            return
        }
        
        if isItalicFormatted(in: text, range: range) {
            // Remove italic formatting
            text[range].font = .system(size: 17, weight: .regular, design: .default)
        } else {
            // Apply italic formatting
            text[range].font = .system(size: 17, weight: .regular, design: .default).italic()
        }
    }
    
    /// Toggles underline formatting on the selected text
    static func toggleUnderline(text: inout AttributedString, selectedRange: Range<AttributedString.Index>?) {
        guard let range = getCurrentRange(for: text, selectedRange: selectedRange), !range.isEmpty else {
            // If no selection, add underline text
            var underlineText = AttributedString("underline text")
            underlineText.underlineStyle = .single
            text.append(AttributedString(" "))
            text.append(underlineText)
            return
        }
        
        if isUnderlineFormatted(in: text, range: range) {
            // Remove underline formatting
            text[range].underlineStyle = .none
        } else {
            // Apply underline formatting
            text[range].underlineStyle = .single
        }
    }
    
    /// Toggles strikethrough formatting on the selected text
    static func toggleStrikethrough(text: inout AttributedString, selectedRange: Range<AttributedString.Index>?) {
        guard let range = getCurrentRange(for: text, selectedRange: selectedRange), !range.isEmpty else {
            // If no selection, add strikethrough text
            var strikeText = AttributedString("strikethrough text")
            strikeText.strikethroughStyle = .single
            text.append(AttributedString(" "))
            text.append(strikeText)
            return
        }
        
        if isStrikethroughFormatted(in: text, range: range) {
            // Remove strikethrough formatting
            text[range].strikethroughStyle = .none
        } else {
            // Apply strikethrough formatting
            text[range].strikethroughStyle = .single
        }
    }
    
    /// Adds a link to the selected text
    static func addLink(text: inout AttributedString, selectedRange: Range<AttributedString.Index>?) {
        guard let range = getCurrentRange(for: text, selectedRange: selectedRange), !range.isEmpty else {
            // If no selection, add link text
            var linkText = AttributedString("link text")
            linkText.link = URL(string: "https://example.com")
            text.append(AttributedString(" "))
            text.append(linkText)
            return
        }
        
        // Apply link to selected text
        text[range].link = URL(string: "https://example.com")
    }
}

// MARK: - Formatting-Only Menu Component (for text selection)
struct MessageComposerFormattingMenu: View {
    @Binding var text: AttributedString
    @Binding var selectedRange: Range<AttributedString.Index>?

    // Computed properties to check current formatting state
    private var isBoldActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isBoldFormatted(in: text, range: range)
    }

    private var isItalicActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isItalicFormatted(in: text, range: range)
    }

    private var isUnderlineActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isUnderlineFormatted(in: text, range: range)
    }

    private var isStrikethroughActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isStrikethroughFormatted(in: text, range: range)
    }

    var body: some View {
        Menu {
            // Formatting options only - no attachments or mentions
            // Displayed at top level when text is selected
            Button(action: {
                TextFormattingHelper.toggleBold(text: &text, selectedRange: selectedRange)
            }) {
                Label(isBoldActive ? "Bold (is selected)" : "Bold", systemImage: "bold")
            }
            .tint(.primary)

            Button(action: {
                TextFormattingHelper.toggleItalic(text: &text, selectedRange: selectedRange)
            }) {
                Label(isItalicActive ? "Italic (is selected)" : "Italic", systemImage: "italic")
            }
            .tint(.primary)

            Button(action: {
                TextFormattingHelper.toggleUnderline(text: &text, selectedRange: selectedRange)
            }) {
                Label(isUnderlineActive ? "Underline (is selected)" : "Underline", systemImage: "underline")
            }
            .tint(.primary)

            Button(action: {
                TextFormattingHelper.toggleStrikethrough(text: &text, selectedRange: selectedRange)
            }) {
                Label(isStrikethroughActive ? "Strikethrough (is selected)" : "Strikethrough", systemImage: "strikethrough")
            }
            .tint(.primary)

            Button(action: {
                TextFormattingHelper.addLink(text: &text, selectedRange: selectedRange)
            }) {
                Label("Link", systemImage: "link")
            }
            .tint(.primary)
        } label: {
            Image(systemName: "bold.italic.underline")
        }
    }
}

// MARK: - Full Format Menu Component (with attachments/mentions)
struct MessageComposerFormatMenu: View {
    @Binding var text: AttributedString
    @Binding var selectedRange: Range<AttributedString.Index>?

    // Computed properties to check current formatting state
    private var isBoldActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isBoldFormatted(in: text, range: range)
    }

    private var isItalicActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isItalicFormatted(in: text, range: range)
    }

    private var isUnderlineActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isUnderlineFormatted(in: text, range: range)
    }

    private var isStrikethroughActive: Bool {
        guard let range = TextFormattingHelper.getCurrentRange(for: text, selectedRange: selectedRange),
              !range.isEmpty else { return false }
        return TextFormattingHelper.isStrikethroughFormatted(in: text, range: range)
    }
    
    var body: some View {
        Menu {
            // Format submenu - moved to top
            Menu {
                Button(action: {
                    TextFormattingHelper.addLink(text: &text, selectedRange: selectedRange)
                }) {
                    Label("Link", systemImage: "link")
                }
                .tint(.primary)
                
                Button(action: {
                    TextFormattingHelper.toggleStrikethrough(text: &text, selectedRange: selectedRange)
                }) {
                    Label(isStrikethroughActive ? "Strikethrough (is selected)" : "Strikethrough", systemImage: "strikethrough")
                }
                .tint(.primary)
                
                Button(action: {
                    TextFormattingHelper.toggleUnderline(text: &text, selectedRange: selectedRange)
                }) {
                    Label(isUnderlineActive ? "Underline (is selected)" : "Underline", systemImage: "underline")
                }
                .tint(.primary)
                
                Button(action: {
                    TextFormattingHelper.toggleItalic(text: &text, selectedRange: selectedRange)
                }) {
                    Label(isItalicActive ? "Italic (is selected)" : "Italic", systemImage: "italic")
                }
                .tint(.primary)
                
                Button(action: {
                    TextFormattingHelper.toggleBold(text: &text, selectedRange: selectedRange)
                }) {
                    Label(isBoldActive ? "Bold (is selected)" : "Bold", systemImage: "bold")
                }
                .tint(.primary)
            } label: {
                Label("Format", systemImage: "bold.italic.underline")
            }
            .tint(.primary)
            
            Divider()
            
            Button(action: {
                // Record
            }) {
                Label("Record", systemImage: "waveform")
            }
            .tint(.primary)
            
            Button(action: {
                // Attach
            }) {
                Label("Attach", systemImage: "paperclip")
            }
            .tint(.primary)
            
            Button(action: {
                // GIF
            }) {
                Label("GIF", systemImage: "rectangle.3.group")
            }
            .tint(.primary)
            
            Button(action: {
                // Image
            }) {
                Label("Image", systemImage: "photo")
            }
            .tint(.primary)
            
            Divider()
            
            Button(action: {
                // Mention
                text.append(AttributedString(" @"))
            }) {
                Label("Mention", systemImage: "at")
            }
            .tint(.primary)
            
            Button(action: {
                // Tag content
                text.append(AttributedString(" #"))
            }) {
                Label("Tag content", systemImage: "number")
            }
            .tint(.primary)
        } label: {
            Image(systemName: "plus")
        }
    }
}

// MARK: - Message Composer with Safe Area
struct MessageComposerWithSafeArea: View {
    @Binding var text: AttributedString
    @Binding var selection: AttributedTextSelection
    @FocusState.Binding var isFocused: Bool
    var placeholder: String = "Add comment"
    var onSubmit: (() -> Void)?
    var onDragStart: (() -> Void)?

    var body: some View {
        // The main content goes here
        Color.clear
            .safeAreaInset(edge: .bottom) {
                // The MessageComposer becomes the safe area inset
                // This ensures it responds to keyboard and stays at the bottom
                MessageComposer(
                    text: $text,
                    selection: $selection,
                    isFocused: $isFocused,
                    placeholder: placeholder,
                    onSubmit: onSubmit,
                    onDragStart: onDragStart
                )
            }
    }
}

#Preview {
    @Previewable @State var text = AttributedString("")
    @Previewable @State var selection = AttributedTextSelection()
    @FocusState var isFocused: Bool

    ZStack {
        // Background to showcase glass effect
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            Spacer()

            // Show different states
            VStack(spacing: 20) {
                Text("iOS 26 Floating Input - Figma Design")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("States: Inactive, Active, Active Input")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()
            }
            .padding()

            MessageComposerWithSafeArea(
                text: $text,
                selection: $selection,
                isFocused: $isFocused,
                placeholder: "Add message",
                onSubmit: {
                    print("Submit: \(text)")
                    text = AttributedString("")
                }
            )
        }
    }
}