//
//  EnhancedSummarizeSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// Enhanced AI Summary Sheet with Apple Intelligence-inspired glass effects
/// Features adaptive tinting, lensing effects, and fluid animations
struct EnhancedSummarizeSheet: View {
    @State private var isLoading = true
    @State private var processingState: AIGlassEffect.ProcessingState = .idle
    @State private var selectedGlassStyle: GlassStyle = .adaptive
    @State private var showGlassOptions = false
    
    enum GlassStyle: String, CaseIterable {
        case adaptive = "Adaptive"
        case fluid = "Fluid"
        case ai = "AI Intelligence"
        case classic = "Classic"
    }
    
    var body: some View {
        SheetTemplate {
            ScrollView {
                VStack(spacing: 0) {
                    // Enhanced header with glass style selector
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AI Summary")
                                .font(.title3.bold())
                                .foregroundColor(.primary)
                            
                            Text("Powered by Intelligence")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showGlassOptions.toggle()
                        }) {
                            Image(systemName: "sparkles")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Glass style picker
                    if showGlassOptions {
                        VStack(spacing: 12) {
                            Text("Glass Effect Style")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                ForEach(GlassStyle.allCases, id: \.self) { style in
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedGlassStyle = style
                                        }
                                    }) {
                                        Text(style.rawValue)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selectedGlassStyle == style ? .blue.opacity(0.2) : .clear)
                                            )
                                            .foregroundColor(selectedGlassStyle == style ? .blue : .primary)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    }
                    
                    // Main content with selected glass effect
                    Group {
                        switch selectedGlassStyle {
                        case .adaptive:
                            adaptiveGlassContent
                        case .fluid:
                            fluidGlassContent
                        case .ai:
                            aiGlassContent
                        case .classic:
                            classicGlassContent
                        }
                    }
                    .onAppear {
                        startProcessing()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
    
    // MARK: - Glass Effect Variations
    
    private var adaptiveGlassContent: some View {
        AdaptiveGlassEffect(
            baseColor: .white,
            accentColor: .blue,
            intensity: 0.4,
            enableLensing: true
        ) {
            VStack(spacing: 16) {
                if isLoading {
                    loadingContent
                } else {
                    completedContent
                }
            }
            .padding(20)
        }
        .frame(minHeight: 300)
        .padding(.horizontal, 20)
    }
    
    private var fluidGlassContent: some View {
        FluidGlassAnimations(glassColor: .purple, enableShimmer: true) {
            VStack(spacing: 16) {
                if isLoading {
                    loadingContent
                } else {
                    completedContent
                }
            }
            .padding(20)
        }
        .frame(minHeight: 300)
        .padding(.horizontal, 20)
    }
    
    private var aiGlassContent: some View {
        AIGlassEffect(processingState: processingState) {
            VStack(spacing: 16) {
                if isLoading {
                    loadingContent
                } else {
                    completedContent
                }
            }
            .padding(20)
        }
        .frame(minHeight: 300)
        .padding(.horizontal, 20)
    }
    
    private var classicGlassContent: some View {
        VStack(spacing: 16) {
            if isLoading {
                loadingContent
            } else {
                completedContent
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .frame(minHeight: 300)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Content Components
    
    private var loadingContent: some View {
        VStack(spacing: 12) {
            // Enhanced skeleton with glass effect
            ForEach(0..<5, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray.opacity(0.2),
                                Color.gray.opacity(0.1)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, CGFloat(index * 20 + 20))
                    .overlay(
                        ShimmerEffect()
                    )
            }
            
            // Processing indicator
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Text("Analyzing content with AI...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
    }
    
    private var completedContent: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                
                Text("Summary Complete")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Key Insights:")
                    .font(.subheadline.bold())
                    .foregroundColor(.primary)
                
                Text("• Content analyzed using advanced AI algorithms")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("• Summary generated with contextual understanding")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("• Ready for review and sharing")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Action buttons with glass effects
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                    }
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    )
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Export")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.blue, lineWidth: 1)
                    )
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Processing Logic
    
    private func startProcessing() {
        processingState = .processing
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isLoading = false
                processingState = .complete
            }
        }
    }
}

#Preview {
    EnhancedSummarizeSheet()
}
