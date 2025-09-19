//
//  HeartIcon.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=5-2434&p=f&t=yPG9JEmux6qoTlmT-11
//

import SwiftUI

struct HeartIcon: View {
    let isFilled: Bool
    let size: CGFloat
    let color: Color
    
    init(isFilled: Bool = false, size: CGFloat = 20, color: Color = .secondary) {
        self.isFilled = isFilled
        self.size = size
        self.color = color
    }
    
    var body: some View {
        ZStack {
            if isFilled {
                // Filled heart
                Image(systemName: "heart.fill")
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(.red)
            } else {
                // Outline heart - using custom SVG path from Figma
                HeartShape()
                    .stroke(color, lineWidth: 1.5)
                    .frame(width: size, height: size)
            }
        }
    }
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Scale the Figma coordinates to fit the rect
        let scaleX = rect.width / 18.0
        let scaleY = rect.height / 15.96
        
        // Heart path based on Figma vector data
        // Starting from the top of the heart
        path.move(to: CGPoint(x: 9 * scaleX, y: 2.5 * scaleY))
        
        // Left curve
        path.addCurve(
            to: CGPoint(x: 2 * scaleX, y: 6 * scaleY),
            control1: CGPoint(x: 2 * scaleX, y: 3 * scaleY),
            control2: CGPoint(x: 2 * scaleX, y: 4.5 * scaleY)
        )
        
        // Left bottom curve
        path.addCurve(
            to: CGPoint(x: 9 * scaleX, y: 13.5 * scaleY),
            control1: CGPoint(x: 2 * scaleX, y: 9 * scaleY),
            control2: CGPoint(x: 5 * scaleX, y: 12 * scaleY)
        )
        
        // Right bottom curve
        path.addCurve(
            to: CGPoint(x: 16 * scaleX, y: 6 * scaleY),
            control1: CGPoint(x: 13 * scaleX, y: 12 * scaleY),
            control2: CGPoint(x: 16 * scaleX, y: 9 * scaleY)
        )
        
        // Right curve
        path.addCurve(
            to: CGPoint(x: 9 * scaleX, y: 2.5 * scaleY),
            control1: CGPoint(x: 16 * scaleX, y: 4.5 * scaleY),
            control2: CGPoint(x: 16 * scaleX, y: 3 * scaleY)
        )
        
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 20) {
            HeartIcon(isFilled: false, size: 20)
            HeartIcon(isFilled: true, size: 20)
        }
        
        HStack(spacing: 20) {
            HeartIcon(isFilled: false, size: 24, color: .red)
            HeartIcon(isFilled: true, size: 24, color: .red)
        }
        
        HStack(spacing: 20) {
            HeartIcon(isFilled: false, size: 16, color: .blue)
            HeartIcon(isFilled: true, size: 16, color: .blue)
        }
    }
    .padding()
}
