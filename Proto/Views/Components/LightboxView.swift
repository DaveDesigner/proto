//
//  LightboxView.swift
//  Proto
//
//  Lightbox component for expanding and collapsing images with smooth animations
//  TODO: Enhance magnification controls and transition animations
//

import SwiftUI
import UIKit

// MARK: - Image Scaling Modifier
struct ImageScalingModifier: ViewModifier {
    let isFillMode: Bool
    
    func body(content: Content) -> some View {
        if isFillMode {
            content
                .scaledToFill()
                .clipped()
        } else {
            content
                .scaledToFit()
        }
    }
}

// MARK: - UIScrollView Wrapper for Enhanced Image Interaction
struct ImageScrollView: UIViewRepresentable {
    let image: UIImage
    let isDarkMode: Bool
    let onSingleTap: () -> Void
    let onDoubleTap: () -> Void
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let imageView = UIImageView(image: image)
        
        // Configure scroll view
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = isDarkMode ? .black : .white
        
        // Configure image view
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .clear
        
        // Add image view to scroll view
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        // Set up constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        // Add gesture recognizers
        let singleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleSingleTap))
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        singleTap.require(toFail: doubleTap)
        
        scrollView.addGestureRecognizer(singleTap)
        scrollView.addGestureRecognizer(doubleTap)
        
        // Store references in coordinator
        context.coordinator.scrollView = scrollView
        context.coordinator.imageView = imageView
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.backgroundColor = isDarkMode ? .black : .white
        context.coordinator.imageView?.image = image
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: ImageScrollView
        var scrollView: UIScrollView?
        var imageView: UIImageView?
        
        init(_ parent: ImageScrollView) {
            self.parent = parent
        }
        
        @objc func handleSingleTap() {
            parent.onSingleTap()
        }
        
        @objc func handleDoubleTap() {
            parent.onDoubleTap()
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            // Center the image when zoomed
            let boundsSize = scrollView.bounds.size
            var contentsFrame = imageView?.frame ?? .zero
            
            if contentsFrame.size.width < boundsSize.width {
                contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
            } else {
                contentsFrame.origin.x = 0.0
            }
            
            if contentsFrame.size.height < boundsSize.height {
                contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
            } else {
                contentsFrame.origin.y = 0.0
            }
            
            imageView?.frame = contentsFrame
        }
    }
}

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
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    @State private var isFillMode: Bool = false
    @State private var showToolbar: Bool = false
    @State private var imageSize: CGSize = .zero
    @State private var dismissOffset: CGSize = .zero
    @State private var isDismissing: Bool = false
    @State private var useScrollView: Bool = true // New flag to enable UIScrollView
    @State private var loadedImage: UIImage? = nil
    @Environment(\.dismiss) private var dismiss
    
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
                
                
                // TEST: Simplified image content - removed complex conditional logic
                // This should reduce view hierarchy complexity during transitions
                imageContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .offset(panOffset)
            }
            .offset(dismissOffset)
            .gesture(
                // Only apply SwiftUI gestures when not using UIScrollView
                useScrollView ? nil : SimultaneousGesture(
                    // Double tap to toggle between fit and fill modes
                    TapGesture(count: 2)
                        .onEnded {
                            handleDoubleTap()
                            showToolbarIfNeeded()
                        },
                    // Single tap to toggle dark mode (only when not in fill mode) or show toolbar
                    TapGesture(count: 1)
                        .onEnded {
                            if !isFillMode {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isDarkMode.toggle()
                                }
                            }
                            showToolbarIfNeeded()
                        }
                )
            )
            .gesture(
                // Pan gesture only when in fill mode and not using UIScrollView
                (useScrollView || !isFillMode) ? nil : DragGesture()
                    .onChanged { value in
                        handleDragGesture(value, in: geometry)
                        showToolbarIfNeeded()
                    }
                    .onEnded { value in
                        handleDragEnd(value, in: geometry)
                    }
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(showToolbar ? .visible : .hidden, for: .navigationBar)
    }
    
    // Enhanced image content with UIScrollView support
    @ViewBuilder
    private var imageContent: some View {
        if useScrollView, let loadedImage = loadedImage {
            // Use UIScrollView for enhanced interaction
            ImageScrollView(
                image: loadedImage,
                isDarkMode: isDarkMode,
                onSingleTap: {
                    if !isFillMode {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isDarkMode.toggle()
                        }
                    }
                    showToolbarIfNeeded()
                },
                onDoubleTap: {
                    // UIScrollView handles double-tap zoom natively
                    showToolbarIfNeeded()
                }
            )
        } else {
            // Fallback to original SwiftUI implementation
            if let sourceImage = sourceImage {
                sourceImage
                    .resizable()
                    .modifier(ImageScalingModifier(isFillMode: isFillMode))
                    .onAppear {
                        loadImageFromSource(sourceImage)
                    }
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .modifier(ImageScalingModifier(isFillMode: isFillMode))
                    .onAppear {
                        loadImageFromName(imageName)
                    }
            } else if let imageURL = imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .modifier(ImageScalingModifier(isFillMode: isFillMode))
                        .onAppear {
                            loadImageFromAsync(image)
                        }
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
    }
    
    // MARK: - Image Loading Helpers
    
    private func loadImageFromSource(_ image: Image) {
        // For source images, we need to convert to UIImage
        // This is a simplified approach - in production you might want to pass UIImage directly
        if let imageName = imageName {
            loadedImage = UIImage(named: imageName)
        } else {
            // Fallback to default image size
            imageSize = CGSize(width: 1200, height: 900)
        }
    }
    
    private func loadImageFromName(_ imageName: String) {
        loadedImage = UIImage(named: imageName)
        if let image = loadedImage {
            imageSize = image.size
        } else {
            imageSize = CGSize(width: 1200, height: 900)
        }
    }
    
    private func loadImageFromAsync(_ image: Image) {
        // For AsyncImage, we can't easily extract UIImage
        // This is a limitation - in production you might want to use a different approach
        imageSize = CGSize(width: 1200, height: 900)
    }
    
    // MARK: - Scaling and Pan Logic
    
    private func handleDoubleTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isFillMode {
                // Switch back to scaledToFit
                panOffset = .zero
                lastPanOffset = .zero
                dismissOffset = .zero
                isDismissing = false
                isFillMode = false
            } else {
                // Switch to scaledToFill - center the image horizontally
                // When switching to fill mode, we want to center the image
                // This assumes the image will be wider than the screen in fill mode
                panOffset = CGSize(width: 0, height: 0) // Center horizontally, keep vertical centered
                lastPanOffset = panOffset
                dismissOffset = .zero
                isDismissing = false
                isFillMode = true
            }
        }
    }
    
    private func showToolbarIfNeeded() {
        if !showToolbar {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToolbar = true
            }
        }
    }
    
    private func constrainPanOffset(_ offset: CGSize, in geometry: GeometryProxy) -> CGSize {
        // Calculate which dimension the image overflows when in scale to fill mode
        let screenAspectRatio = geometry.size.width / geometry.size.height
        let imageAspectRatio = imageSize.width / imageSize.height
        
        var constrainedX = offset.width
        var constrainedY = offset.height
        
        // Determine which axis should allow dragging based on aspect ratio
        if imageAspectRatio > screenAspectRatio {
            // Image is wider than screen - allow horizontal dragging only
            // Calculate the maximum horizontal pan distance
            let scaledImageWidth = geometry.size.height * imageAspectRatio
            let horizontalOverflow = (scaledImageWidth - geometry.size.width) / 2
            let maxPanDistance = horizontalOverflow
            
            constrainedX = min(maxPanDistance, max(-maxPanDistance, offset.width))
            constrainedY = 0 // Lock vertical movement
        } else {
            // Image is taller than screen - allow vertical dragging only
            // Calculate the maximum vertical pan distance
            let scaledImageHeight = geometry.size.width / imageAspectRatio
            let verticalOverflow = (scaledImageHeight - geometry.size.height) / 2
            let maxPanDistance = verticalOverflow
            
            constrainedX = 0 // Lock horizontal movement
            constrainedY = min(maxPanDistance, max(-maxPanDistance, offset.height))
        }
        
        return CGSize(width: constrainedX, height: constrainedY)
    }
    
    // MARK: - Drag and Dismiss Logic
    
    private func handleDragGesture(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let screenAspectRatio = geometry.size.width / geometry.size.height
        let imageAspectRatio = imageSize.width / imageSize.height
        
        let translation = value.translation
        let dismissThreshold: CGFloat = 50 // Lower threshold for more responsive dismiss
        
        if imageAspectRatio > screenAspectRatio {
            // Image is wider - horizontal panning, vertical dismissing
            let newPanX = lastPanOffset.width + translation.width
            let newDismissY = translation.height
            
            // Constrain horizontal panning
            let scaledImageWidth = geometry.size.height * imageAspectRatio
            let horizontalOverflow = (scaledImageWidth - geometry.size.width) / 2
            let constrainedPanX = min(horizontalOverflow, max(-horizontalOverflow, newPanX))
            
            // Check if we've hit the horizontal boundary and should start dismissing
            let hitLeftBoundary = newPanX <= -horizontalOverflow && translation.width < 0
            let hitRightBoundary = newPanX >= horizontalOverflow && translation.width > 0
            
            if hitLeftBoundary || hitRightBoundary {
                // Start dismissing when hitting horizontal boundaries
                isDismissing = true
                // Apply the excess movement as dismiss offset
                let excessMovement = newPanX - constrainedPanX
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: excessMovement, height: newDismissY)
            } else if abs(newDismissY) > dismissThreshold {
                // Start dismissing based on vertical movement threshold
                isDismissing = true
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: 0, height: newDismissY)
            } else {
                // Normal panning within boundaries
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: 0, height: newDismissY)
            }
        } else {
            // Image is taller - vertical panning, horizontal dismissing
            let newPanY = lastPanOffset.height + translation.height
            let newDismissX = translation.width
            
            // Constrain vertical panning
            let scaledImageHeight = geometry.size.width / imageAspectRatio
            let verticalOverflow = (scaledImageHeight - geometry.size.height) / 2
            let constrainedPanY = min(verticalOverflow, max(-verticalOverflow, newPanY))
            
            // Check if we've hit the vertical boundary and should start dismissing
            let hitTopBoundary = newPanY <= -verticalOverflow && translation.height < 0
            let hitBottomBoundary = newPanY >= verticalOverflow && translation.height > 0
            
            if hitTopBoundary || hitBottomBoundary {
                // Start dismissing when hitting vertical boundaries
                isDismissing = true
                // Apply the excess movement as dismiss offset
                let excessMovement = newPanY - constrainedPanY
                panOffset = CGSize(width: 0, height: constrainedPanY)
                dismissOffset = CGSize(width: newDismissX, height: excessMovement)
            } else if abs(newDismissX) > dismissThreshold {
                // Start dismissing based on horizontal movement threshold
                isDismissing = true
                panOffset = CGSize(width: 0, height: constrainedPanY)
                dismissOffset = CGSize(width: newDismissX, height: 0)
            } else {
                // Normal panning within boundaries
                panOffset = CGSize(width: 0, height: constrainedPanY)
                dismissOffset = CGSize(width: newDismissX, height: 0)
            }
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let screenAspectRatio = geometry.size.width / geometry.size.height
        let imageAspectRatio = imageSize.width / imageSize.height
        
        let translation = value.translation
        let dismissThreshold: CGFloat = 50
        let dismissVelocity: CGFloat = 500 // Velocity threshold for dismiss
        
        if imageAspectRatio > screenAspectRatio {
            // Image is wider - check dismiss conditions
            let dismissY = dismissOffset.height
            let dismissX = dismissOffset.width
            let velocityY = value.velocity.height
            let velocityX = value.velocity.width
            
            // Check if we should dismiss based on movement or velocity
            let shouldDismiss = isDismissing && (
                abs(dismissY) > dismissThreshold || 
                abs(dismissX) > dismissThreshold ||
                abs(velocityY) > dismissVelocity ||
                abs(velocityX) > dismissVelocity
            )
            
            if shouldDismiss {
                // Dismiss the view
                withAnimation(.easeInOut(duration: 0.3)) {
                    opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismiss()
                }
            } else {
                // Reset dismiss state
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    dismissOffset = .zero
                    isDismissing = false
                }
                lastPanOffset = panOffset
            }
        } else {
            // Image is taller - check dismiss conditions
            let dismissX = dismissOffset.width
            let dismissY = dismissOffset.height
            let velocityX = value.velocity.width
            let velocityY = value.velocity.height
            
            // Check if we should dismiss based on movement or velocity
            let shouldDismiss = isDismissing && (
                abs(dismissX) > dismissThreshold || 
                abs(dismissY) > dismissThreshold ||
                abs(velocityX) > dismissVelocity ||
                abs(velocityY) > dismissVelocity
            )
            
            if shouldDismiss {
                // Dismiss the view
                withAnimation(.easeInOut(duration: 0.3)) {
                    opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismiss()
                }
            } else {
                // Reset dismiss state
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    dismissOffset = .zero
                    isDismissing = false
                }
                lastPanOffset = panOffset
            }
        }
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
