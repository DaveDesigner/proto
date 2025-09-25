//
//  Image.swift
//  Proto
//
//  Image component with Unsplash placeholder functionality
//

import SwiftUI

struct ImageComponent: View {
    let width: Int
    let height: Int
    let imageIndex: Int
    let cornerRadius: CGFloat
    let content: ((Image) -> AnyView)?
    let enableLightbox: Bool
    
    @State private var imageName: String = ""
    @State private var isLoading: Bool = true
    @Namespace private var animationNamespace
    
    init(
        width: Int = 400,
        height: Int = 300,
        imageIndex: Int = 0,
        cornerRadius: CGFloat = 16,
        content: ((Image) -> AnyView)? = nil,
        enableLightbox: Bool = true
    ) {
        self.width = width
        self.height = height
        self.imageIndex = imageIndex
        self.cornerRadius = cornerRadius
        self.content = content
        self.enableLightbox = enableLightbox
    }
    
    var body: some View {
        Group {
            if !imageName.isEmpty && !isLoading {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(width), height: CGFloat(height))
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .overlay(
                        content?(Image(imageName))
                    )
                    .matchedGeometryEffect(
                        id: "image-\(imageName)-\(imageIndex)",
                        in: animationNamespace
                    )
                    .onTapGesture {
                        if enableLightbox {
                            // Trigger the lightbox with animation
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                LightboxManager.shared.present(
                                    imageName: imageName,
                                    sourceImage: Image(imageName),
                                    animationID: "image-\(imageName)-\(imageIndex)"
                                )
                            }
                        }
                    }
            } else if isLoading {
                loadingView
            } else {
                // Fallback view if image fails to load
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: CGFloat(width), height: CGFloat(height))
                    .overlay(
                        VStack {
                            Text("Image \(imageIndex)")
                                .font(.caption)
                                .foregroundColor(.white)
                            Text("Failed to load")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private var loadingView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.3))
            .frame(width: CGFloat(width), height: CGFloat(height))
            .overlay(
                VStack(spacing: 8) {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading image...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            )
    }
    
    private func loadImage() {
        isLoading = true
        
        // Load image immediately
        DispatchQueue.main.async {
            // Select image based on index for sequential assignment
            let placeholderImages = getAvailableImages()
            let index = imageIndex % placeholderImages.count
            imageName = placeholderImages[index]
            isLoading = false
        }
    }
    
    private func getAvailableImages() -> [String] {
        return [
            "Post",
            "Feed", 
            "Messages",
            "Notifications",
            "Avatar"
        ]
    }
}

// MARK: - Convenience Initializers
extension ImageComponent {
    /// Create an image component for post previews
    static func postImage(imageIndex: Int = 0, enableLightbox: Bool = true) -> ImageComponent {
        ImageComponent(
            width: 400,
            height: 250,
            imageIndex: imageIndex,
            cornerRadius: 12,
            enableLightbox: enableLightbox
        )
    }
    
    /// Create an image component for feed images
    static func feedImage(imageIndex: Int = 0, enableLightbox: Bool = true) -> ImageComponent {
        ImageComponent(
            width: 400,
            height: 300,
            imageIndex: imageIndex,
            cornerRadius: 16,
            enableLightbox: enableLightbox
        )
    }
    
    /// Create a square image component for avatars or thumbnails
    static func squareImage(size: Int = 100, imageIndex: Int = 0, enableLightbox: Bool = false) -> ImageComponent {
        ImageComponent(
            width: size,
            height: size,
            imageIndex: imageIndex,
            cornerRadius: CGFloat(size / 2),
            enableLightbox: enableLightbox
        )
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("Image Component with Lightbox")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            
            Text("Tap any image to open in lightbox mode")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Post Images (Lightbox Enabled)")
                    .font(.headline)
                ImageComponent.postImage(imageIndex: 0)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Feed Images (Lightbox Enabled)")
                    .font(.headline)
                ImageComponent.feedImage(imageIndex: 1)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Another Post Image")
                    .font(.headline)
                ImageComponent.postImage(imageIndex: 2)
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Square Images (Lightbox Disabled)")
                        .font(.headline)
                    HStack {
                        ImageComponent.squareImage(size: 60, imageIndex: 3, enableLightbox: false)
                        ImageComponent.squareImage(size: 60, imageIndex: 4, enableLightbox: false)
                        ImageComponent.squareImage(size: 60, imageIndex: 5, enableLightbox: false)
                    }
                }
            }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
