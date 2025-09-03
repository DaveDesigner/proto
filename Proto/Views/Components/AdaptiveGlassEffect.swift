//
//  AdaptiveGlassEffect.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// An adaptive glass effect that dynamically adjusts its tint based on content and environment
/// Inspired by Apple Intelligence's Liquid Glass design language
struct AdaptiveGlassEffect: View {
    @State private var tintIntensity: Double = 0.0
    @State private var lensingOffset: CGSize = .zero
    @State private var isAnimating = false
    
    let baseColor: Color
    let accentColor: Color
    let intensity: Double
    let enableLensing: Bool
    
    init(
        baseColor: Color = .white,
        accentColor: Color = .blue,
        intensity: Double = 0.3,
        enableLensing: Bool = true
    ) {
        self.baseColor = baseColor
        self.accentColor = accentColor
        self.intensity = intensity
        self.enableLensing = enableLensing
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base glass layer
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                baseColor.opacity(0.1 + tintIntensity * 0.2),
                                baseColor.opacity(0.05 + tintIntensity * 0.15)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(.ultraThinMaterial)
                    .overlay(
                        // Accent tint overlay
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        accentColor.opacity(0.1 + tintIntensity * 0.3),
                                        accentColor.opacity(0.05 + tintIntensity * 0.2),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: geometry.size.width * 0.8
                                )
                            )
                    )
                    .overlay(
                        // Lensing effect
                        Group {
                            if enableLensing {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.2 + tintIntensity * 0.1),
                                                Color.clear
                                            ]),
                                            center: UnitPoint(
                                                x: 0.3 + lensingOffset.width / geometry.size.width,
                                                y: 0.3 + lensingOffset.height / geometry.size.height
                                            ),
                                            startRadius: 0,
                                            endRadius: geometry.size.width * 0.4
                                        )
                                    )
                                    .blendMode(.overlay)
                            }
                        }
                    )
                    .overlay(
                        // Subtle border
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.3 + tintIntensity * 0.2),
                                        Color.white.opacity(0.1 + tintIntensity * 0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            }
        }
        .onAppear {
            startAdaptiveAnimation()
        }
    }
    
    private func startAdaptiveAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            tintIntensity = intensity
        }
        
        if enableLensing {
            withAnimation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true)
            ) {
                lensingOffset = CGSize(width: 20, height: 15)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AdaptiveGlassEffect(
            baseColor: .white,
            accentColor: .blue,
            intensity: 0.4
        )
        .frame(height: 200)
        
        AdaptiveGlassEffect(
            baseColor: .white,
            accentColor: .purple,
            intensity: 0.6,
            enableLensing: true
        )
        .frame(height: 200)
    }
    .padding()
    .background(
        LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
