//
//  MessageComposer.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct MessageComposer: View {
    @Binding var text: AttributedString
    @FocusState.Binding var isFocused: Bool
    @State private var isHeartFilled = false
    
    var placeholder: String = "Add message"
    var onSubmit: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {            
            // Text editor with AttributedString support
            TextEditor(text: $text)
                .font(.body)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .frame(minHeight: 36)
                .fixedSize(horizontal: false, vertical: true)
            
            // Submit button with glass effect
            Button(action: {
                onSubmit?()
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }
            .disabled(text.characters.isEmpty)
            .opacity(text.characters.isEmpty ? 0.5 : 1.0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Formatting Menu Component
struct MessageComposerFormatMenu: View {
    @Binding var text: AttributedString
    
    var body: some View {
        Menu {
            // Format submenu - moved to top
            Menu {
                Button(action: {
                    // Add link text with proper formatting
                    var linkText = AttributedString("link text")
                    linkText.link = URL(string: "https://example.com")
                    text.append(AttributedString(" "))
                    text.append(linkText)
                }) {
                    Label("Link", systemImage: "link")
                }
                .tint(.primary)
                
                Button(action: {
                    // Add strikethrough text
                    var strikeText = AttributedString("strikethrough text")
                    strikeText.strikethroughStyle = .single
                    text.append(AttributedString(" "))
                    text.append(strikeText)
                }) {
                    Label("Strikethrough", systemImage: "strikethrough")
                }
                .tint(.primary)
                
                Button(action: {
                    // Add underline text
                    var underlineText = AttributedString("underline text")
                    underlineText.underlineStyle = .single
                    text.append(AttributedString(" "))
                    text.append(underlineText)
                }) {
                    Label("Underline", systemImage: "underline")
                }
                .tint(.primary)
                
                Button(action: {
                    // Add italic text
                    var italicText = AttributedString("italic text")
                    italicText.font = .system(size: 17, weight: .regular, design: .default).italic()
                    text.append(AttributedString(" "))
                    text.append(italicText)
                }) {
                    Label("Italic", systemImage: "italic")
                }
                .tint(.primary)
                
                Button(action: {
                    // Add bold text
                    var boldText = AttributedString("bold text")
                    boldText.font = .system(size: 17, weight: .bold, design: .default)
                    text.append(AttributedString(" "))
                    text.append(boldText)
                }) {
                    Label("Bold", systemImage: "bold")
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
    @FocusState.Binding var isFocused: Bool
    var placeholder: String = "Add comment"
    var onSubmit: (() -> Void)?
    
    var body: some View {
        // The main content goes here
        Color.clear
            .safeAreaInset(edge: .bottom) {
                // The MessageComposer becomes the safe area inset
                // This ensures it responds to keyboard and stays at the bottom
                MessageComposer(
                    text: $text,
                    isFocused: $isFocused,
                    placeholder: placeholder,
                    onSubmit: onSubmit
                )
            }
    }
}

#Preview {
    @Previewable @State var text = AttributedString("")
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