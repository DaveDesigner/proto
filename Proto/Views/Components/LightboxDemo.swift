//
//  LightboxDemo.swift
//  Proto
//
//  Demo view showcasing lightbox image expansion and collapse behavior
//

import SwiftUI

struct LightboxDemo: View {
    @State private var selectedImageIndex = 0
    @State private var showLightbox = false
    
    private let demoImages = [
        "Post",
        "Avatar", 
        "Messages",
        "Notifications"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Lightbox Demo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Tap any image to expand it in lightbox mode")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Feature highlights
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "hand.tap", text: "Tap to expand images")
                            FeatureRow(icon: "arrow.up.left.and.arrow.down.right", text: "Pinch to zoom in/out")
                            FeatureRow(icon: "hand.draw", text: "Drag to pan around")
                            FeatureRow(icon: "xmark.circle", text: "Tap background or close button to dismiss")
                            FeatureRow(icon: "arrow.down", text: "Swipe down to dismiss")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Image grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(0..<demoImages.count, id: \.self) { index in
                            ImageComponent.feedImage(imageIndex: index)
                                .onTapGesture {
                                    selectedImageIndex = index
                                    showLightbox = true
                                }
                        }
                    }
                    
                    // Individual image examples
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Individual Examples")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            ImageComponent.postImage(imageIndex: 0)
                            ImageComponent.postImage(imageIndex: 1)
                            ImageComponent.postImage(imageIndex: 2)
                        }
                    }
                    
                    // Instructions
                    VStack(spacing: 12) {
                        Text("Try These Interactions:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            InstructionRow(number: "1", text: "Tap any image above to open it in lightbox")
                            InstructionRow(number: "2", text: "Use pinch gestures to zoom in and out")
                            InstructionRow(number: "3", text: "Drag to pan around the zoomed image")
                            InstructionRow(number: "4", text: "Tap the background or close button to dismiss")
                            InstructionRow(number: "5", text: "Swipe down on the image to dismiss")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Lightbox Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .lightbox(
            isPresented: $showLightbox,
            imageName: demoImages[selectedImageIndex]
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

struct InstructionRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(Color.blue)
                .clipShape(Circle())
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    LightboxDemo()
}
