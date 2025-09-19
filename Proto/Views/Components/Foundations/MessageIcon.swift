//
//  MessageIcon.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=5-2434&p=f&t=yPG9JEmux6qoTlmT-11
//

import SwiftUI

struct MessageIcon: View {
    let size: CGFloat
    let color: Color
    
    init(size: CGFloat = 20, color: Color = .secondary) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Message bubble outline
            MessageBubbleShape()
                .stroke(color, lineWidth: 1.5)
                .frame(width: size, height: size)
            
            // Three dots inside the bubble
            HStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(color)
                        .frame(width: 1.5, height: 1.5)
                }
            }
            .offset(y: 2)
        }
    }
}

struct MessageBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Scale the Figma coordinates to fit the rect
        let scaleX = rect.width / 18.0
        let scaleY = rect.height / 18.0
        
        // Message bubble path based on Figma vector data
        // Starting from the top-left corner
        path.move(to: CGPoint(x: 2 * scaleX, y: 2 * scaleY))
        
        // Top edge
        path.addLine(to: CGPoint(x: 16 * scaleX, y: 2 * scaleY))
        
        // Right edge
        path.addLine(to: CGPoint(x: 16 * scaleX, y: 12 * scaleY))
        
        // Bottom-right curve
        path.addCurve(
            to: CGPoint(x: 12 * scaleX, y: 16 * scaleY),
            control1: CGPoint(x: 16 * scaleX, y: 14 * scaleY),
            control2: CGPoint(x: 14 * scaleX, y: 16 * scaleY)
        )
        
        // Bottom-left curve
        path.addCurve(
            to: CGPoint(x: 8 * scaleX, y: 14 * scaleY),
            control1: CGPoint(x: 10 * scaleX, y: 16 * scaleY),
            control2: CGPoint(x: 8 * scaleX, y: 15 * scaleY)
        )
        
        // Left edge
        path.addLine(to: CGPoint(x: 2 * scaleX, y: 12 * scaleY))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 20) {
            MessageIcon(size: 20)
            MessageIcon(size: 20, color: .red)
        }
        
        HStack(spacing: 20) {
            MessageIcon(size: 24, color: .blue)
            MessageIcon(size: 16, color: .green)
        }
        
        HStack(spacing: 20) {
            MessageIcon(size: 32, color: .purple)
            MessageIcon(size: 18, color: .orange)
        }
    }
    .padding()
}
