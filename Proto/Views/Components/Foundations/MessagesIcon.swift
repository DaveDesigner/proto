//
//  MessagesIcon.swift
//  Proto
//
//  Generated from Figma component
//  Based on messages.svg
//

import SwiftUI

struct MessagesIcon: View {
    let size: CGFloat
    let color: Color
    
    init(size: CGFloat = 24, color: Color = .primary) {
        self.size = size
        self.color = color
    }
    
    var body: some View {
        MessagesIconShape()
            .stroke(color, lineWidth: 1.5)
            .frame(width: size, height: size)
    }
}

struct MessagesIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Scale the SVG coordinates to fit the rect
        let scaleX = rect.width / 24.0
        let scaleY = rect.height / 24.0
        
        // SVG path data from messages.svg
        // M7.01085 20.6686C8.47917 21.5154 10.1828 21.9999 11.9996 21.9999C17.5225 21.9999 22 17.5228 22 12C22 6.47715 17.5228 2 12 2C6.47715 2 2 6.47715 2 12C2 13.8168 2.48449 15.5204 3.33133 16.9888L3.33461 16.9944C3.41609 17.1357 3.45718 17.207 3.47579 17.2743C3.49334 17.3378 3.49824 17.3949 3.49375 17.4606C3.48892 17.5312 3.46511 17.6045 3.41631 17.7509L2.56207 20.3136L2.56099 20.317C2.38075 20.8577 2.29063 21.128 2.35487 21.3082C2.41088 21.4653 2.53521 21.5892 2.69227 21.6452C2.87202 21.7093 3.14116 21.6196 3.6795 21.4402L3.6862 21.4377L6.24894 20.5834C6.39486 20.5348 6.46904 20.5101 6.53955 20.5053C6.60528 20.5008 6.66197 20.5068 6.72548 20.5243C6.79298 20.543 6.86426 20.5841 7.00626 20.666L7.01085 20.6686Z
        
        // Move to start point
        path.move(to: CGPoint(x: 7.01085 * scaleX, y: 20.6686 * scaleY))
        
        // First curve
        path.addCurve(
            to: CGPoint(x: 11.9996 * scaleX, y: 21.9999 * scaleY),
            control1: CGPoint(x: 8.47917 * scaleX, y: 21.5154 * scaleY),
            control2: CGPoint(x: 10.1828 * scaleX, y: 21.9999 * scaleY)
        )
        
        // Second curve
        path.addCurve(
            to: CGPoint(x: 22 * scaleX, y: 12 * scaleY),
            control1: CGPoint(x: 17.5225 * scaleX, y: 21.9999 * scaleY),
            control2: CGPoint(x: 22 * scaleX, y: 17.5228 * scaleY)
        )
        
        // Third curve
        path.addCurve(
            to: CGPoint(x: 12 * scaleX, y: 2 * scaleY),
            control1: CGPoint(x: 22 * scaleX, y: 6.47715 * scaleY),
            control2: CGPoint(x: 17.5228 * scaleX, y: 2 * scaleY)
        )
        
        // Fourth curve
        path.addCurve(
            to: CGPoint(x: 2 * scaleX, y: 12 * scaleY),
            control1: CGPoint(x: 6.47715 * scaleX, y: 2 * scaleY),
            control2: CGPoint(x: 2 * scaleX, y: 6.47715 * scaleY)
        )
        
        // Fifth curve
        path.addCurve(
            to: CGPoint(x: 3.33133 * scaleX, y: 16.9888 * scaleY),
            control1: CGPoint(x: 2 * scaleX, y: 13.8168 * scaleY),
            control2: CGPoint(x: 2.48449 * scaleX, y: 15.5204 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 3.33461 * scaleX, y: 16.9944 * scaleY))
        
        // Sixth curve
        path.addCurve(
            to: CGPoint(x: 3.47579 * scaleX, y: 17.2743 * scaleY),
            control1: CGPoint(x: 3.41609 * scaleX, y: 17.1357 * scaleY),
            control2: CGPoint(x: 3.45718 * scaleX, y: 17.207 * scaleY)
        )
        
        // Seventh curve
        path.addCurve(
            to: CGPoint(x: 3.49375 * scaleX, y: 17.4606 * scaleY),
            control1: CGPoint(x: 3.49334 * scaleX, y: 17.3378 * scaleY),
            control2: CGPoint(x: 3.49824 * scaleX, y: 17.3949 * scaleY)
        )
        
        // Eighth curve
        path.addCurve(
            to: CGPoint(x: 3.41631 * scaleX, y: 17.7509 * scaleY),
            control1: CGPoint(x: 3.48892 * scaleX, y: 17.5312 * scaleY),
            control2: CGPoint(x: 3.46511 * scaleX, y: 17.6045 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 2.56207 * scaleX, y: 20.3136 * scaleY))
        
        // Line to next point
        path.addLine(to: CGPoint(x: 2.56099 * scaleX, y: 20.317 * scaleY))
        
        // Ninth curve
        path.addCurve(
            to: CGPoint(x: 2.35487 * scaleX, y: 21.3082 * scaleY),
            control1: CGPoint(x: 2.38075 * scaleX, y: 20.8577 * scaleY),
            control2: CGPoint(x: 2.29063 * scaleX, y: 21.128 * scaleY)
        )
        
        // Tenth curve
        path.addCurve(
            to: CGPoint(x: 2.69227 * scaleX, y: 21.6452 * scaleY),
            control1: CGPoint(x: 2.41088 * scaleX, y: 21.4653 * scaleY),
            control2: CGPoint(x: 2.53521 * scaleX, y: 21.5892 * scaleY)
        )
        
        // Eleventh curve
        path.addCurve(
            to: CGPoint(x: 3.6795 * scaleX, y: 21.4402 * scaleY),
            control1: CGPoint(x: 2.87202 * scaleX, y: 21.7093 * scaleY),
            control2: CGPoint(x: 3.14116 * scaleX, y: 21.6196 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 3.6862 * scaleX, y: 21.4377 * scaleY))
        
        // Line to next point
        path.addLine(to: CGPoint(x: 6.24894 * scaleX, y: 20.5834 * scaleY))
        
        // Twelfth curve
        path.addCurve(
            to: CGPoint(x: 6.53955 * scaleX, y: 20.5053 * scaleY),
            control1: CGPoint(x: 6.39486 * scaleX, y: 20.5348 * scaleY),
            control2: CGPoint(x: 6.46904 * scaleX, y: 20.5101 * scaleY)
        )
        
        // Thirteenth curve
        path.addCurve(
            to: CGPoint(x: 6.72548 * scaleX, y: 20.5243 * scaleY),
            control1: CGPoint(x: 6.60528 * scaleX, y: 20.5008 * scaleY),
            control2: CGPoint(x: 6.66197 * scaleX, y: 20.5068 * scaleY)
        )
        
        // Fourteenth curve
        path.addCurve(
            to: CGPoint(x: 7.00626 * scaleX, y: 20.666 * scaleY),
            control1: CGPoint(x: 6.79298 * scaleX, y: 20.543 * scaleY),
            control2: CGPoint(x: 6.86426 * scaleX, y: 20.5841 * scaleY)
        )
        
        // Line to final point
        path.addLine(to: CGPoint(x: 7.01085 * scaleX, y: 20.6686 * scaleY))
        
        return path
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 20) {
            MessagesIcon(size: 16, color: .primary)
            MessagesIcon(size: 20, color: .secondary)
            MessagesIcon(size: 24, color: .accentColor)
        }
        
        HStack(spacing: 20) {
            MessagesIcon(size: 16, color: .red)
            MessagesIcon(size: 20, color: .blue)
            MessagesIcon(size: 24, color: .green)
        }
    }
    .padding()
}
