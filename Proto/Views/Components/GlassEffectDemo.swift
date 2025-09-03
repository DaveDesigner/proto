//
//  GlassEffectDemo.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

/// Demo view showcasing different glass effect approaches inspired by Apple Intelligence
/// This view demonstrates various tinting, lensing, and animation techniques
struct GlassEffectDemo: View {
    @State private var selectedDemo: DemoType = .adaptive
    @State private var isAnimating = true
    
    enum DemoType: String, CaseIterable {
        case adaptive = "Adaptive Tinting"
        case fluid = "Fluid Animations"
        case ai = "AI Intelligence"
        case lensing = "Lensing Effects"
        case comparison = "Style Comparison"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Glass Effect Exploration")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        
                        Text("Apple Intelligence-Inspired Design Patterns")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Demo type picker
                    Picker("Demo Type", selection: $selectedDemo) {
                        ForEach(DemoType.allCases, id: \.self) { demo in
                            Text(demo.rawValue).tag(demo)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    
                    // Demo content
                    Group {
                        switch selectedDemo {
                        case .adaptive:
                            adaptiveDemo
                        case .fluid:
                            fluidDemo
                        case .ai:
                            aiDemo
                        case .lensing:
                            lensingDemo
                        case .comparison:
                            comparisonDemo
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Demo Variations
    
    private var adaptiveDemo: some View {
        VStack(spacing: 20) {
            Text("Adaptive Tinting")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Glass effects that dynamically adjust their tint based on content and environment, similar to Apple Intelligence's adaptive interface elements.")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                AdaptiveGlassEffect(
                    baseColor: .white,
                    accentColor: .blue,
                    intensity: 0.4
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Blue Tint")
                            .font(.headline)
                        Text("Adaptive blue tinting with lensing effects")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 120)
                
                AdaptiveGlassEffect(
                    baseColor: .white,
                    accentColor: .purple,
                    intensity: 0.6
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Purple Tint")
                            .font(.headline)
                        Text("Higher intensity purple tinting")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 120)
                
                AdaptiveGlassEffect(
                    baseColor: .white,
                    accentColor: .green,
                    intensity: 0.3,
                    enableLensing: false
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Green Tint (No Lensing)")
                            .font(.headline)
                        Text("Subtle green tint without lensing effects")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 120)
            }
        }
    }
    
    private var fluidDemo: some View {
        VStack(spacing: 20) {
            Text("Fluid Animations")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Interactive glass effects with fluid animations that respond to user gestures and interactions.")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                FluidGlassAnimations(glassColor: .blue) {
                    VStack(spacing: 8) {
                        Text("Tap & Drag")
                            .font(.headline)
                        Text("Interactive fluid glass with shimmer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
                
                FluidGlassAnimations(glassColor: .purple, enableShimmer: false) {
                    VStack(spacing: 8) {
                        Text("No Shimmer")
                            .font(.headline)
                        Text("Fluid animations without shimmer effect")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
            }
        }
    }
    
    private var aiDemo: some View {
        VStack(spacing: 20) {
            Text("AI Intelligence Effects")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Specialized glass effects for AI-related content with processing states and intelligence-inspired animations.")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                AIGlassEffect(processingState: .idle) {
                    VStack(spacing: 8) {
                        Text("Idle State")
                            .font(.headline)
                        Text("AI glass effect in idle state")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
                
                AIGlassEffect(processingState: .processing) {
                    VStack(spacing: 8) {
                        Text("Processing State")
                            .font(.headline)
                        Text("AI processing with sparkles and rotation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
                
                AIGlassEffect(processingState: .complete) {
                    VStack(spacing: 8) {
                        Text("Complete State")
                            .font(.headline)
                        Text("AI processing completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
            }
        }
    }
    
    private var lensingDemo: some View {
        VStack(spacing: 20) {
            Text("Lensing Effects")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Advanced lensing effects that create depth and physicality by bending and shaping light in real-time.")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                AdaptiveGlassEffect(
                    baseColor: .white,
                    accentColor: .cyan,
                    intensity: 0.5,
                    enableLensing: true
                ) {
                    VStack(spacing: 8) {
                        Text("Cyan Lensing")
                            .font(.headline)
                        Text("Cyan tint with advanced lensing effects")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 120)
                
                AdaptiveGlassEffect(
                    baseColor: .white,
                    accentColor: .orange,
                    intensity: 0.7,
                    enableLensing: true
                ) {
                    VStack(spacing: 8) {
                        Text("Orange Lensing")
                            .font(.headline)
                        Text("High intensity orange with lensing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .frame(height: 120)
            }
        }
    }
    
    private var comparisonDemo: some View {
        VStack(spacing: 20) {
            Text("Style Comparison")
                .font(.title2.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Side-by-side comparison of different glass effect approaches.")
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    // Classic glass
                    VStack(spacing: 8) {
                        Text("Classic")
                            .font(.caption.bold())
                        
                        VStack(spacing: 8) {
                            Text("Standard")
                                .font(.caption)
                            Text("Glass")
                                .font(.caption)
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Adaptive glass
                    VStack(spacing: 8) {
                        Text("Adaptive")
                            .font(.caption.bold())
                        
                        AdaptiveGlassEffect(
                            baseColor: .white,
                            accentColor: .blue,
                            intensity: 0.4
                        ) {
                            VStack(spacing: 8) {
                                Text("Adaptive")
                                    .font(.caption)
                                Text("Glass")
                                    .font(.caption)
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 120)
                
                HStack(spacing: 12) {
                    // Fluid glass
                    VStack(spacing: 8) {
                        Text("Fluid")
                            .font(.caption.bold())
                        
                        FluidGlassAnimations(glassColor: .purple) {
                            VStack(spacing: 8) {
                                Text("Fluid")
                                    .font(.caption)
                                Text("Glass")
                                    .font(.caption)
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // AI glass
                    VStack(spacing: 8) {
                        Text("AI")
                            .font(.caption.bold())
                        
                        AIGlassEffect(processingState: .processing) {
                            VStack(spacing: 8) {
                                Text("AI")
                                    .font(.caption)
                                Text("Glass")
                                    .font(.caption)
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 120)
            }
        }
    }
}

#Preview {
    GlassEffectDemo()
}
