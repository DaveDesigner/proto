//
//  LightboxView.swift
//  Proto
//
//  Lightbox component for expanding and collapsing images with smooth animations
//

import SwiftUI


// MARK: - Lightbox Navigation Link
struct LightboxNavigationLink<Label: View>: View {
    let imageName: String?
    let imageURL: URL?
    let sourceImage: Image?
    let sourceID: String
    let namespace: Namespace.ID
    let label: () -> Label
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        imageName: String? = nil,
        imageURL: URL? = nil,
        sourceImage: Image? = nil,
        sourceID: String,
        namespace: Namespace.ID,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.sourceImage = sourceImage
        self.sourceID = sourceID
        self.namespace = namespace
        self.label = label
    }
    
    var body: some View {
        NavigationLink {
            LightboxView(
                imageName: imageName,
                imageURL: imageURL,
                sourceImage: sourceImage,
                sourceID: sourceID,
                namespace: namespace
            )
            .navigationTransition(.zoom(sourceID: sourceID, in: namespace))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        } label: {
            label()
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct LightboxView: View {
    let imageName: String?
    let imageURL: URL?
    let sourceImage: Image?
    let sourceID: String?
    let namespace: Namespace.ID
    
    @State private var opacity: Double = 0.0
    @State private var isAnimating: Bool = false
    @State private var isDarkMode: Bool = true
    @State private var zoomScale: CGFloat = 1.0
    @State private var lastZoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    @State private var isZoomed: Bool = false
    
    init(
        imageName: String? = nil,
        imageURL: URL? = nil,
        sourceImage: Image? = nil,
        sourceID: String? = nil,
        namespace: Namespace.ID
    ) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.sourceImage = sourceImage
        self.sourceID = sourceID
        self.namespace = namespace
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background overlay
                (isDarkMode ? Color.black : Color.white)
                    .opacity(opacity)
                    .ignoresSafeArea()
                
                // Image content - centered in full screen, ignoring safe area
                Group {
                    // Prioritize source image for seamless transition
                    if let sourceImage = sourceImage {
                        sourceImage
                            .resizable()
                            .scaledToFit()
                    } else if let imageName = imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                    } else if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            // Use source image as placeholder if available
                            if let sourceImage = sourceImage {
                                sourceImage
                                    .resizable()
                                    .scaledToFit()
                                    .opacity(0.7)
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: isDarkMode ? .white : .black))
                                    .scaleEffect(1.5)
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Text("No image")
                                    .foregroundColor(isDarkMode ? .white : .black)
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .scaleEffect(zoomScale)
                .offset(panOffset)
                .gesture(
                    SimultaneousGesture(
                        // Double tap to zoom
                        TapGesture(count: 2)
                            .onEnded {
                                handleDoubleTap()
                            },
                        // Single tap to toggle dark mode (only when not zoomed)
                        TapGesture(count: 1)
                            .onEnded {
                                if !isZoomed {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isDarkMode.toggle()
                                    }
                                }
                            }
                    )
                )
                .gesture(
                    // Pan gesture only when zoomed
                    isZoomed ? DragGesture()
                        .onChanged { value in
                            // When zoomed, handle panning within the image
                            let newOffset = CGSize(
                                width: lastPanOffset.width + value.translation.width,
                                height: lastPanOffset.height + value.translation.height
                            )
                            panOffset = constrainPanOffset(newOffset, in: geometry)
                        }
                        .onEnded { _ in
                            lastPanOffset = panOffset
                        } : nil
                )
                .onAppear {
                    isAnimating = true
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        opacity = 1.0
                    }
                    
                    // Add a slight delay to ensure the matchedGeometryEffect completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            isAnimating = false
                        }
                    }
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    // MARK: - Zoom and Pan Logic
    
    private func handleDoubleTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isZoomed {
                // Reset to original size
                zoomScale = 1.0
                panOffset = .zero
                lastZoomScale = 1.0
                lastPanOffset = .zero
                isZoomed = false
            } else {
                // Zoom to fill screen
                zoomScale = calculateZoomToFill()
                lastZoomScale = zoomScale
                panOffset = .zero
                lastPanOffset = .zero
                isZoomed = true
            }
        }
    }
    
    private func calculateZoomToFill() -> CGFloat {
        // Calculate zoom to fill screen while maintaining aspect ratio
        // We want to zoom so that the image fills the entire screen height or width
        // This ensures the image touches the top/bottom edges for landscape images
        // or left/right edges for portrait images
        
        // Since we're using scaledToFit, we need to calculate the zoom factor
        // that will make the image fill the screen dimension that's currently smaller
        // A factor of 3.0 typically works well for most images to fill screen edges
        return 3.0
    }
    
    private func constrainPanOffset(_ offset: CGSize, in geometry: GeometryProxy) -> CGSize {
        let screenWidth = geometry.size.width
        let screenHeight = geometry.size.height
        
        // Calculate the scaled image dimensions
        let scaledWidth = screenWidth * zoomScale
        let scaledHeight = screenHeight * zoomScale
        
        // Calculate maximum allowed offset to keep image edges visible
        let maxOffsetX = max(0, (scaledWidth - screenWidth) / 2)
        let maxOffsetY = max(0, (scaledHeight - screenHeight) / 2)
        
        // Constrain the offset
        let constrainedX = min(maxOffsetX, max(-maxOffsetX, offset.width))
        let constrainedY = min(maxOffsetY, max(-maxOffsetY, offset.height))
        
        return CGSize(width: constrainedX, height: constrainedY)
    }
    
}


// MARK: - View Extension
extension View {
    /// iOS 18 zoom transition lightbox using NavigationLink
    func lightboxNavigation(
        imageName: String? = nil,
        imageURL: URL? = nil,
        sourceImage: Image? = nil,
        sourceID: String,
        namespace: Namespace.ID
    ) -> some View {
        LightboxNavigationLink(
            imageName: imageName,
            imageURL: imageURL,
            sourceImage: sourceImage,
            sourceID: sourceID,
            namespace: namespace
        ) {
            self
        }
    }
}

// MARK: - Preview
#Preview {
    struct LightboxPreview: View {
        @Namespace private var animationNamespace
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Tap the image to see iOS 18 zoom transition")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("This uses NavigationLink with zoom transition")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Image("Post")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 150)
                        .clipped()
                        .cornerRadius(12)
                        .matchedTransitionSource(id: "preview-image", in: animationNamespace)
                        .lightboxNavigation(
                            imageName: "Post",
                            sourceImage: Image("Post"),
                            sourceID: "preview-image",
                            namespace: animationNamespace
                        )
                }
                .padding()
            }
        }
    }
    
    return LightboxPreview()
}
