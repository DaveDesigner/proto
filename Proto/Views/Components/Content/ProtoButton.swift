//
//  ProtoButton.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// A reusable button component matching the Figma design system
/// with primary and secondary states using iOS 26 glass effects.
///
/// Usage:
/// ```swift
/// // Primary button (dark, prominent)
/// ProtoButton("Message", style: .primary) {
///     sendMessage()
/// }
///
/// // Secondary button (light, subtle)
/// ProtoButton("Edit Profile", style: .secondary) {
///     editProfile()
/// }
///
/// // With custom styling
/// ProtoButton("Save", style: .primary, fullWidth: true) {
///     save()
/// }
/// ```

enum ProtoButtonStyle {
    case primary
    case secondary
}

struct ProtoButton: View {
    let title: String
    let style: ProtoButtonStyle
    let fullWidth: Bool
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    init(
        _ title: String,
        style: ProtoButtonStyle = .primary,
        fullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.fullWidth = fullWidth
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .foregroundStyle(textColor)
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .padding(.vertical, 16)
                .padding(.horizontal, 48)
        }
        .buttonStyle(PlainButtonStyle())
        .glassEffect(
            style == .primary
                ? .regular.tint(.primary).interactive()
                : .regular.interactive()
        )
    }

    private var textColor: Color {
        switch style {
        case .primary:
            // Primary button: white text on dark background (inverts in dark mode)
            return colorScheme == .light ? .white : .black
        case .secondary:
            // Secondary button: uses primary text color
            return .primary
        }
    }
}

// MARK: - Preview
#Preview("Button Styles") {
    VStack(spacing: 24) {
        Text("Primary Button")
            .font(.headline)
        ProtoButton("Message", style: .primary) {
            print("Primary tapped")
        }

        Text("Secondary Button")
            .font(.headline)
        ProtoButton("Edit Profile", style: .secondary) {
            print("Secondary tapped")
        }

        Text("Full Width Primary")
            .font(.headline)
        ProtoButton("Continue", style: .primary, fullWidth: true) {
            print("Full width tapped")
        }
        .padding(.horizontal)

        Text("Full Width Secondary")
            .font(.headline)
        ProtoButton("Cancel", style: .secondary, fullWidth: true) {
            print("Cancel tapped")
        }
        .padding(.horizontal)
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 24) {
        ProtoButton("Message", style: .primary) {
            print("Primary tapped")
        }

        ProtoButton("Edit Profile", style: .secondary) {
            print("Secondary tapped")
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}
