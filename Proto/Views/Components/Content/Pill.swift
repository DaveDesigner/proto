//
//  Pill.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// A reusable pill component for displaying member tags, badges, and categories
/// using iOS 26 glass effects similar to the inactive segment control state.
///
/// Usage:
/// ```swift
/// // Simple text pill
/// Pill("Circle Team")
///
/// // Pill with emoji
/// Pill("🔥 Speaker")
///
/// // Custom styling
/// Pill("Designer", style: .prominent)
/// ```

enum PillStyle {
    case regular    // Light glass effect (default)
    case prominent  // More visible, tinted
}

struct Pill: View {
    let text: String
    let emoji: String?
    let style: PillStyle

    init(_ text: String, emoji: String? = nil, style: PillStyle = .regular) {
        self.text = text
        self.emoji = emoji
        self.style = style
    }

    var body: some View {
        HStack(spacing: 4) {
            if let emoji = emoji {
                Text(emoji)
                    .font(.system(size: 14))
            }
            Text(text)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .glassEffect(
            style == .prominent
                ? .regular.tint(.secondary).interactive()
                : .regular.interactive()
        )
    }
}

// MARK: - Preview
#Preview("Pill Styles") {
    VStack(spacing: 24) {
        Text("Member Tags")
            .font(.headline)

        // Example from Figma: badges wrapping
        FlowLayout(spacing: 8) {
            Pill("Circle Affiliate")
            Pill("Circle Team")
            Pill("Speaker", emoji: "🔥")
            Pill("Storyteller", emoji: "⛺️")
            Pill("Designer", emoji: "🖌️")
        }
        .padding(.horizontal)

        Text("Regular Style")
            .font(.headline)
        HStack(spacing: 8) {
            Pill("Tag 1")
            Pill("Tag 2")
            Pill("Tag 3")
        }

        Text("Prominent Style")
            .font(.headline)
        HStack(spacing: 8) {
            Pill("Featured", style: .prominent)
            Pill("New", style: .prominent)
        }
    }
    .padding()
}

// MARK: - Flow Layout Helper
/// A simple flow layout that wraps pills horizontally
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    // Move to next line
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
