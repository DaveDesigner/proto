//
//  CommentIcon.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=1844-19523&m=dev
//

import SwiftUI

struct CommentIcon: View {
    let size: CGFloat
    let color: Color
    
    init(size: CGFloat = 20, color: Color = .secondary) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            // Comment bubble shape
            CommentBubbleShape()
                .stroke(color, lineWidth: 1.5)
                .frame(width: size, height: size)
        }
    }
}

struct CommentBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Scale the Figma coordinates to fit the rect
        let scaleX = rect.width / 20.0
        let scaleY = rect.height / 20.0
        
        // Comment bubble path based on Figma vector data
        // This creates a speech bubble with a tail pointing down-right
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        
        // Main bubble body (rounded rectangle)
        let bubbleWidth = 16 * scaleX
        let bubbleHeight = 12 * scaleY
        let cornerRadius = 2 * scaleX
        
        let bubbleRect = CGRect(
            x: centerX - bubbleWidth / 2,
            y: centerY - bubbleHeight / 2,
            width: bubbleWidth,
            height: bubbleHeight
        )
        
        // Create rounded rectangle for main bubble
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Add tail pointing down-right
        let tailStartX = centerX + bubbleWidth / 2 - 2 * scaleX
        let tailStartY = centerY + bubbleHeight / 2 - 2 * scaleY
        let tailEndX = centerX + bubbleWidth / 2 + 4 * scaleX
        let tailEndY = centerY + bubbleHeight / 2 + 4 * scaleY
        
        path.move(to: CGPoint(x: tailStartX, y: tailStartY))
        path.addLine(to: CGPoint(x: tailEndX, y: tailEndY))
        path.addLine(to: CGPoint(x: tailStartX + 2 * scaleX, y: tailEndY))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 20) {
            CommentIcon(size: 20)
            CommentIcon(size: 20, color: .red)
        }
        
        HStack(spacing: 20) {
            CommentIcon(size: 24, color: .blue)
            CommentIcon(size: 16, color: .green)
        }
        
        HStack(spacing: 20) {
            CommentIcon(size: 32, color: .purple)
            CommentIcon(size: 18, color: .orange)
        }
    }
    .padding()
}
