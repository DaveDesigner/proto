//
//  FluidGlassAnimations.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// Fluid animations for glass effects that respond to user interactions
/// Inspired by Apple Intelligence's responsive design patterns
struct FluidGlassAnimations: View {
    @State private var isPressed = false
    @State private var dragOffset: CGSize = .zero
    @State private var rotationAngle: Double = 0
    @State private var scale: Double = 1.0
    @State private var shimmerOffset: CGFloat = -1.0
    
    let content: AnyView
    let glassColor: Color
    let enableShimmer: Bool
    
    init<Content: View>(
        glassColor: Color = .white,
        enableShimmer: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.glassColor = glassColor
        self.enableShimmer = enableShimmer
        self.content = AnyView(content())
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Base glass background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            // Dynamic tint based on interaction
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            glassColor.opacity(0.1 + (isPressed ? 0.2 : 0.0)),
                                            glassColor.opacity(0.05 + (isPressed ? 0.15 : 0.0))
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .overlay(
                            // Shimmer effect
                            Group {
                                if enableShimmer {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.clear,
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(width: 100)
                                    .offset(x: shimmerOffset * 200)
                                    .blendMode(.overlay)
                                }
                            }
                        )
                        .overlay(
                            // Interactive border
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.4 + (isPressed ? 0.2 : 0.0)),
                                            Color.white.opacity(0.2 + (isPressed ? 0.1 : 0.0))
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1 + (isPressed ? 0.5 : 0.0)
                                )
                        )
                }
            )
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotationAngle))
            .offset(dragOffset)
            .onTapGesture {
                performTapAnimation()
            }
            .onLongPressGesture(minimumDuration: 0.1) {
                // Long press handling
            } onPressingChanged: { pressing in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = pressing
                    scale = pressing ? 0.98 : 1.0
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.interactiveSpring()) {
                            dragOffset = value.translation
                            rotationAngle = value.translation.width * 0.1
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            dragOffset = .zero
                            rotationAngle = 0
                        }
                    }
            )
            .onAppear {
                startShimmerAnimation()
            }
    }
    
    private func performTapAnimation() {
        withAnimation(.easeInOut(duration: 0.1)) {
            scale = 0.95
        }
        
        withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
            scale = 1.0
        }
        
        // Ripple effect
        withAnimation(.easeOut(duration: 0.3)) {
            rotationAngle = 2
        }
        
        withAnimation(.easeInOut(duration: 0.3).delay(0.1)) {
            rotationAngle = 0
        }
    }
    
    private func startShimmerAnimation() {
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            shimmerOffset = 1.0
        }
    }
}

/// A specialized glass effect for AI-related content with intelligence-inspired animations
struct AIGlassEffect: View {
    @State private var sparkleOpacity: Double = 0.0
    @State private var gradientOffset: CGFloat = 0.0
    @State private var isProcessing = false
    
    let content: AnyView
    let processingState: ProcessingState
    
    enum ProcessingState {
        case idle
        case processing
        case complete
    }
    
    init<Content: View>(
        processingState: ProcessingState = .idle,
        @ViewBuilder content: () -> Content
    ) {
        self.processingState = processingState
        self.content = AnyView(content())
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Base AI glass background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            // AI-inspired gradient
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue.opacity(0.1),
                                            Color.purple.opacity(0.1),
                                            Color.cyan.opacity(0.1)
                                        ]),
                                        startPoint: UnitPoint(x: gradientOffset, y: 0),
                                        endPoint: UnitPoint(x: gradientOffset + 1, y: 1)
                                    )
                                )
                        )
                        .overlay(
                            // Sparkle effects for AI processing
                            Group {
                                if processingState == .processing {
                                    ForEach(0..<5, id: \.self) { index in
                                        Circle()
                                            .fill(Color.white.opacity(sparkleOpacity))
                                            .frame(width: 4, height: 4)
                                            .offset(
                                                x: CGFloat.random(in: -50...50),
                                                y: CGFloat.random(in: -50...50)
                                            )
                                            .animation(
                                                Animation.easeInOut(duration: 1.0)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(Double(index) * 0.2),
                                                value: sparkleOpacity
                                            )
                                    }
                                }
                            }
                        )
                        .overlay(
                            // Processing indicator
                            Group {
                                if processingState == .processing {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            AngularGradient(
                                                gradient: Gradient(colors: [
                                                    Color.blue,
                                                    Color.purple,
                                                    Color.cyan,
                                                    Color.blue
                                                ]),
                                                center: .center,
                                                startAngle: .degrees(0),
                                                endAngle: .degrees(360)
                                            ),
                                            lineWidth: 2
                                        )
                                        .rotationEffect(.degrees(gradientOffset * 360))
                                }
                            }
                        )
                }
            )
            .onAppear {
                startAIAnimations()
            }
            .onChange(of: processingState) { newState in
                updateAnimationsForState(newState)
            }
    }
    
    private func startAIAnimations() {
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            gradientOffset = 1.0
        }
        
        if processingState == .processing {
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                sparkleOpacity = 0.8
            }
        }
    }
    
    private func updateAnimationsForState(_ state: ProcessingState) {
        switch state {
        case .idle:
            sparkleOpacity = 0.0
        case .processing:
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                sparkleOpacity = 0.8
            }
        case .complete:
            withAnimation(.easeOut(duration: 0.5)) {
                sparkleOpacity = 0.0
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        FluidGlassAnimations(glassColor: .blue) {
            VStack {
                Text("Fluid Glass Animation")
                    .font(.headline)
                Text("Tap and drag to interact")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .frame(height: 100)
        
        AIGlassEffect(processingState: .processing) {
            VStack {
                Text("AI Glass Effect")
                    .font(.headline)
                Text("Processing state with sparkles")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .frame(height: 100)
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
