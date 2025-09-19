//
//  Divider.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=8-2553&t=yPG9JEmux6qoTlmT-1
//

import SwiftUI

struct Divider: View {
    let variant: DividerVariant
    let color: Color
    
    init(variant: DividerVariant = .list, color: Color = Color(.quaternaryLabel)) {
        self.variant = variant
        self.color = color
    }
    
    var body: some View {
        switch variant {
        case .list:
            // List divider with symmetric spacing above and below
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 8) // 8pt top padding
                
                Rectangle()
                    .fill(color)
                    .frame(height: 0.75) // 0.75pt stroke weight from Figma
                    .padding(.horizontal, 20) // 20pt horizontal padding from Figma
                
                Spacer()
                    .frame(height: 8) // 8pt bottom padding
            }
            .frame(height: 16.75) // Total height: 8 + 0.75 + 8 = 16.75pt
        case .section:
            // Section divider - thicker and more prominent with symmetric spacing
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 8) // 8pt top padding
                
                Rectangle()
                    .fill(color)
                    .frame(height: 1.0) // Slightly thicker for section dividers
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 8) // 8pt bottom padding
            }
            .frame(height: 17) // Total height: 8 + 1.0 + 8 = 17pt
        case .minimal:
            // Minimal divider - just the line
            Rectangle()
                .fill(color)
                .frame(height: 0.75)
                .padding(.horizontal, 20)
        case .fullWidth:
            // Full width divider with vertical padding only (for use in padded containers)
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 16) // 16pt top padding
                
                Rectangle()
                    .fill(color)
                    .frame(height: 0.75) // 0.75pt stroke weight
                
                Spacer()
                    .frame(height: 16) // 16pt bottom padding
            }
            .frame(height: 32.75) // Total height: 16 + 0.75 + 16 = 32.75pt
        }
    }
}

enum DividerVariant {
    case list      // 32pt height with padding (from Figma)
    case section   // Thicker divider for major sections
    case minimal   // Just the line, no padding
    case fullWidth // Full width divider with vertical padding only
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("List Divider")
            .font(.headline)
        
        Divider(variant: .list)
        
        Text("Section Divider")
            .font(.headline)
        
        Divider(variant: .section, color: .primary.opacity(0.3))
        
        Text("Minimal Divider")
            .font(.headline)
        
        Divider(variant: .minimal)
        
        Spacer()
    }
    .padding()
}
