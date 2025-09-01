//
//  ShimmerEffect.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct ShimmerEffect: View {
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                
                // Shimmer gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.clear,
                        Color.white.opacity(0.1),
                        Color.clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geometry.size.width * 0.6)
                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width * 0.6)
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 4)
        .fill(Color.gray.opacity(0.2))
        .frame(width: 200, height: 16)
        .overlay(ShimmerEffect())
}
