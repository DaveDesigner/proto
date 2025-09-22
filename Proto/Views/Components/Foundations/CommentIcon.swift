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
        CommentIconShape()
            .stroke(color, lineWidth: 1.5)
            .frame(width: size, height: size)
    }
}

struct CommentIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Scale the SVG coordinates to fit the rect
        let scaleX = rect.width / 20.0
        let scaleY = rect.height / 20.0
        
        // SVG path data from comment.svg
        // M14.4902 17.8018C13.1687 18.5639 11.6355 19 10.0004 19C5.02979 19 1 14.9706 1 10C1 5.02944 5.02944 1 10 1C14.9706 1 19 5.02944 19 10C19 11.6351 18.564 13.1684 17.8018 14.4899L17.7989 14.495C17.7255 14.6221 17.6885 14.6863 17.6718 14.7469C17.656 14.804 17.6516 14.8554 17.6556 14.9146C17.66 14.9781 17.6814 15.044 17.7253 15.1758L18.4941 17.4823L18.4951 17.4853C18.6573 17.9719 18.7384 18.2152 18.6806 18.3774C18.6302 18.5187 18.5183 18.6303 18.377 18.6807C18.2152 18.7384 17.973 18.6577 17.4885 18.4962L17.4824 18.4939L15.176 17.7251C15.0446 17.6813 14.9779 17.6591 14.9144 17.6548C14.8552 17.6507 14.8042 17.6561 14.7471 17.6719C14.6863 17.6887 14.6222 17.7257 14.4944 17.7994L14.4902 17.8018Z
        
        // Move to start point
        path.move(to: CGPoint(x: 14.4902 * scaleX, y: 17.8018 * scaleY))
        
        // First curve
        path.addCurve(
            to: CGPoint(x: 10.0004 * scaleX, y: 19 * scaleY),
            control1: CGPoint(x: 13.1687 * scaleX, y: 18.5639 * scaleY),
            control2: CGPoint(x: 11.6355 * scaleX, y: 19 * scaleY)
        )
        
        // Second curve
        path.addCurve(
            to: CGPoint(x: 1 * scaleX, y: 10 * scaleY),
            control1: CGPoint(x: 5.02979 * scaleX, y: 19 * scaleY),
            control2: CGPoint(x: 1 * scaleX, y: 14.9706 * scaleY)
        )
        
        // Third curve
        path.addCurve(
            to: CGPoint(x: 10 * scaleX, y: 1 * scaleY),
            control1: CGPoint(x: 1 * scaleX, y: 5.02944 * scaleY),
            control2: CGPoint(x: 5.02944 * scaleX, y: 1 * scaleY)
        )
        
        // Fourth curve
        path.addCurve(
            to: CGPoint(x: 19 * scaleX, y: 10 * scaleY),
            control1: CGPoint(x: 14.9706 * scaleX, y: 1 * scaleY),
            control2: CGPoint(x: 19 * scaleX, y: 5.02944 * scaleY)
        )
        
        // Fifth curve
        path.addCurve(
            to: CGPoint(x: 17.8018 * scaleX, y: 14.4899 * scaleY),
            control1: CGPoint(x: 19 * scaleX, y: 11.6351 * scaleY),
            control2: CGPoint(x: 18.564 * scaleX, y: 13.1684 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 17.7989 * scaleX, y: 14.495 * scaleY))
        
        // Sixth curve
        path.addCurve(
            to: CGPoint(x: 17.6718 * scaleX, y: 14.7469 * scaleY),
            control1: CGPoint(x: 17.7255 * scaleX, y: 14.6221 * scaleY),
            control2: CGPoint(x: 17.6885 * scaleX, y: 14.6863 * scaleY)
        )
        
        // Seventh curve
        path.addCurve(
            to: CGPoint(x: 17.6556 * scaleX, y: 14.9146 * scaleY),
            control1: CGPoint(x: 17.656 * scaleX, y: 14.804 * scaleY),
            control2: CGPoint(x: 17.6516 * scaleX, y: 14.8554 * scaleY)
        )
        
        // Eighth curve
        path.addCurve(
            to: CGPoint(x: 17.7253 * scaleX, y: 15.1758 * scaleY),
            control1: CGPoint(x: 17.66 * scaleX, y: 14.9781 * scaleY),
            control2: CGPoint(x: 17.6814 * scaleX, y: 15.044 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 18.4941 * scaleX, y: 17.4823 * scaleY))
        
        // Line to next point
        path.addLine(to: CGPoint(x: 18.4951 * scaleX, y: 17.4853 * scaleY))
        
        // Ninth curve
        path.addCurve(
            to: CGPoint(x: 18.6806 * scaleX, y: 18.3774 * scaleY),
            control1: CGPoint(x: 18.6573 * scaleX, y: 17.9719 * scaleY),
            control2: CGPoint(x: 18.7384 * scaleX, y: 18.2152 * scaleY)
        )
        
        // Tenth curve
        path.addCurve(
            to: CGPoint(x: 18.377 * scaleX, y: 18.6807 * scaleY),
            control1: CGPoint(x: 18.6302 * scaleX, y: 18.5187 * scaleY),
            control2: CGPoint(x: 18.5183 * scaleX, y: 18.6303 * scaleY)
        )
        
        // Eleventh curve
        path.addCurve(
            to: CGPoint(x: 17.4885 * scaleX, y: 18.4962 * scaleY),
            control1: CGPoint(x: 18.2152 * scaleX, y: 18.7384 * scaleY),
            control2: CGPoint(x: 17.973 * scaleX, y: 18.6577 * scaleY)
        )
        
        // Line to next point
        path.addLine(to: CGPoint(x: 17.4824 * scaleX, y: 18.4939 * scaleY))
        
        // Line to next point
        path.addLine(to: CGPoint(x: 15.176 * scaleX, y: 17.7251 * scaleY))
        
        // Twelfth curve
        path.addCurve(
            to: CGPoint(x: 14.9144 * scaleX, y: 17.6548 * scaleY),
            control1: CGPoint(x: 15.0446 * scaleX, y: 17.6813 * scaleY),
            control2: CGPoint(x: 14.9779 * scaleX, y: 17.6591 * scaleY)
        )
        
        // Thirteenth curve
        path.addCurve(
            to: CGPoint(x: 14.7471 * scaleX, y: 17.6719 * scaleY),
            control1: CGPoint(x: 14.8552 * scaleX, y: 17.6507 * scaleY),
            control2: CGPoint(x: 14.8042 * scaleX, y: 17.6561 * scaleY)
        )
        
        // Fourteenth curve
        path.addCurve(
            to: CGPoint(x: 14.4944 * scaleX, y: 17.7994 * scaleY),
            control1: CGPoint(x: 14.6863 * scaleX, y: 17.6887 * scaleY),
            control2: CGPoint(x: 14.6222 * scaleX, y: 17.7257 * scaleY)
        )
        
        // Line to final point
        path.addLine(to: CGPoint(x: 14.4902 * scaleX, y: 17.8018 * scaleY))
        
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
