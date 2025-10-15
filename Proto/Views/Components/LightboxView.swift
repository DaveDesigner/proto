//
//  LightboxView.swift
//  Proto
//
//  Lightbox component for expanding and collapsing images with smooth animations
//  TODO: Enhance magnification controls and transition animations
//

import SwiftUI

// MARK: - Image Scaling Modifier
struct ImageScalingModifier: ViewModifier {
    let isFillMode: Bool
    let magnification: CGFloat
    
    func body(content: Content) -> some View {
        // Use SwiftUI's built-in aspect ratio preservation with magnification
        return content
            .aspectRatio(nil, contentMode: isFillMode ? .fill : .fit)
            .scaleEffect(magnification)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
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
            //.navigationBarTitleDisplayMode(.inline)
            //.toolbarBackground(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        } label: {
            label()
        }
        //.buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Multi-Attachment Lightbox Navigation Link
struct MultiAttachmentLightboxNavigationLink<Label: View>: View {
    let attachments: [MediaAttachment]
    let initialIndex: Int
    let sourceID: String
    let namespace: Namespace.ID
    let sourceImage: Image?
    let label: () -> Label
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        attachments: [MediaAttachment],
        initialIndex: Int = 0,
        sourceID: String,
        namespace: Namespace.ID,
        sourceImage: Image? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.attachments = attachments
        self.initialIndex = initialIndex
        self.sourceID = sourceID
        self.namespace = namespace
        self.sourceImage = sourceImage
        self.label = label
    }
    
    var body: some View {
        NavigationLink {
            MultiAttachmentLightboxView(
                attachments: attachments,
                initialIndex: initialIndex,
                sourceID: sourceID,
                namespace: namespace,
                sourceImage: sourceImage
            )
            .navigationTransition(.zoom(sourceID: sourceID, in: namespace))
            .toolbar(.hidden, for: .tabBar)
        } label: {
            label()
        }
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
    @State private var dismissOffset: CGSize = .zero
    @State private var isDismissing: Bool = false
    @State private var magnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var isZooming: Bool = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var deviceColorScheme
    
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
                SimultaneousGesture(
                    // Double tap to toggle between fit and fill modes
                    TapGesture(count: 2)
                        .onEnded {
                            handleDoubleTap()
                            // Show toolbar only if we're in light mode
                            if !isDarkMode {
                                showToolbarIfNeeded()
                            }
                        },
                    // Single tap to toggle dark mode and show/hide toolbar accordingly
                    TapGesture(count: 1)
                        .onEnded {
                            if !isFillMode {
                                // Only toggle to light mode if device is in light mode
                                if deviceColorScheme == .light {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isDarkMode.toggle()
                                    }
                                    // Show toolbar only in light mode, hide in dark mode (no animation)
                                    showToolbar = !isDarkMode
                                } else {
                                    // In dark mode device, just toggle toolbar visibility
                                    showToolbar.toggle()
                                }
                            } else {
                                // When in fill mode, toggle toolbar visibility regardless of theme
                                showToolbar.toggle()
                            }
                        }
                )
            )
            .gesture(
                // Magnification gesture for pinch to zoom
                MagnificationGesture()
                    .onChanged { value in
                        handleMagnificationGesture(value)
                        // Show toolbar only if we're in light mode
                        if !isDarkMode {
                            showToolbarIfNeeded()
                        }
                    }
                    .onEnded { value in
                        handleMagnificationEnd(value)
                    }
            )
            .gesture(
                // Pan gesture when in fill mode or when zoomed
                (isFillMode || magnification > 1.0) ? DragGesture()
                    .onChanged { value in
                        handleDragGesture(value, in: geometry)
                        // Show toolbar only if we're in light mode
                        if !isDarkMode {
                            showToolbarIfNeeded()
                        }
                    }
                    .onEnded { value in
                        handleDragEnd(value, in: geometry)
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
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar(showToolbar ? .visible : .hidden, for: .navigationBar)
    }
    
    // TEST: Extracted image content to computed property to simplify view hierarchy
    @ViewBuilder
    private var imageContent: some View {
        if let sourceImage = sourceImage {
            sourceImage
                .resizable()
                .modifier(ImageScalingModifier(isFillMode: isFillMode, magnification: magnification))
        } else if let imageName = imageName {
            Image(imageName)
                .resizable()
                .modifier(ImageScalingModifier(isFillMode: isFillMode, magnification: magnification))
        } else if let imageURL = imageURL {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .modifier(ImageScalingModifier(isFillMode: isFillMode, magnification: magnification))
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
    
    // MARK: - Scaling and Pan Logic
    
    private func handleDoubleTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            // If we're in default state (fit mode, no zoom, no pan), zoom in
            if !isFillMode && magnification == 1.0 && panOffset == .zero {
                // Switch to fill mode (zoom in) - center the image
                // When switching to fill mode, we need to center the image
                // For now, we'll use a simple approach and let the pan gesture handle centering
                panOffset = .zero
                lastPanOffset = .zero
                dismissOffset = .zero
                isDismissing = false
                isFillMode = true
                magnification = 1.0
                lastMagnification = 1.0
                isZooming = false
            } else {
                // Return to default state: fit mode, no zoom, no pan
                panOffset = .zero
                lastPanOffset = .zero
                dismissOffset = .zero
                isDismissing = false
                isFillMode = false
                magnification = 1.0
                lastMagnification = 1.0
                isZooming = false
            }
        }
    }
    
    
    private func showToolbarIfNeeded() {
        // Show toolbar if we're in light mode (either device light mode or toggled to light) and toolbar isn't already showing
        if (!isDarkMode || deviceColorScheme == .light) && !showToolbar {
            showToolbar = true
        }
    }
    
    // MARK: - Magnification Gesture Handlers
    
    private func handleMagnificationGesture(_ value: MagnificationGesture.Value) {
        isZooming = true
        magnification = lastMagnification * value
        // Constrain magnification between 0.5x and 5.0x
        magnification = min(max(magnification, 0.5), 5.0)
    }
    
    private func handleMagnificationEnd(_ value: MagnificationGesture.Value) {
        isZooming = false
        lastMagnification = magnification
        
        // If zoomed out too much, reset to 1.0
        if magnification < 1.0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                magnification = 1.0
                lastMagnification = 1.0
                // Reset pan offset when returning to normal zoom
                panOffset = .zero
                lastPanOffset = .zero
            }
        }
    }
    
    private func constrainPanOffset(_ offset: CGSize, in geometry: GeometryProxy) -> CGSize {
        // Simplified pan constraints - allow reasonable panning in fill mode
        let maxPanDistance: CGFloat = 100
        
        let constrainedX = min(maxPanDistance, max(-maxPanDistance, offset.width))
        let constrainedY = min(maxPanDistance, max(-maxPanDistance, offset.height))
        
        return CGSize(width: constrainedX, height: constrainedY)
    }
    
    // MARK: - Drag and Dismiss Logic
    
    private func handleDragGesture(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let translation = value.translation
        let dismissThreshold: CGFloat = 50 // Lower threshold for more responsive dismiss
        
        // Calculate pan constraints based on magnification and fill mode
        let effectiveMagnification = isFillMode ? max(magnification, 1.0) : magnification
        let scaledImageWidth = geometry.size.width * effectiveMagnification
        let scaledImageHeight = geometry.size.height * effectiveMagnification
        
        let horizontalOverflow = max(0, (scaledImageWidth - geometry.size.width) / 2)
        let verticalOverflow = max(0, (scaledImageHeight - geometry.size.height) / 2)
        
        // When zoomed in, allow panning in both directions
        if magnification > 1.0 {
            let newPanX = lastPanOffset.width + translation.width
            let newPanY = lastPanOffset.height + translation.height
            
            // Constrain panning within the zoomed image bounds
            let constrainedPanX = min(horizontalOverflow, max(-horizontalOverflow, newPanX))
            let constrainedPanY = min(verticalOverflow, max(-verticalOverflow, newPanY))
            
            // Check for dismiss gesture (swipe down or up when at edges)
            let hitHorizontalBoundary = abs(newPanX) >= horizontalOverflow
            let hitVerticalBoundary = abs(newPanY) >= verticalOverflow
            
            if (hitHorizontalBoundary || hitVerticalBoundary) && abs(translation.height) > dismissThreshold {
                // Start dismissing when at boundaries and swiping vertically
                isDismissing = true
                panOffset = CGSize(width: constrainedPanX, height: constrainedPanY)
                dismissOffset = CGSize(width: 0, height: translation.height)
            } else {
                // Normal panning within boundaries
                panOffset = CGSize(width: constrainedPanX, height: constrainedPanY)
                dismissOffset = CGSize(width: 0, height: 0)
            }
        } else if isFillMode {
            // Original fill mode logic for horizontal panning
            let newPanX = lastPanOffset.width + translation.width
            let newDismissY = translation.height
            
            let constrainedPanX = min(horizontalOverflow, max(-horizontalOverflow, newPanX))
            
            // Check if we've hit the horizontal boundary and should start dismissing
            let hitLeftBoundary = newPanX <= CGFloat(-horizontalOverflow) && translation.width < 0
            let hitRightBoundary = newPanX >= horizontalOverflow && translation.width > 0
            
            if hitLeftBoundary || hitRightBoundary {
                // Start dismissing when hitting horizontal boundaries
                isDismissing = true
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
            // No panning when in fit mode and not zoomed
            if abs(translation.height) > dismissThreshold {
                isDismissing = true
                dismissOffset = CGSize(width: 0, height: translation.height)
            } else {
                dismissOffset = CGSize(width: 0, height: translation.height)
            }
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let dismissThreshold: CGFloat = 50
        let dismissVelocity: CGFloat = 500 // Velocity threshold for dismiss
        
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
    }
    
}

// MARK: - Multi-Attachment Lightbox View
struct MultiAttachmentLightboxView: View {
    let attachments: [MediaAttachment]
    let initialIndex: Int
    let sourceID: String?
    let namespace: Namespace.ID
    let sourceImage: Image?
    
    @State private var currentIndex: Int
    @State private var opacity: Double = 0.0
    @State private var isAnimating: Bool = false
    @State private var isDarkMode: Bool = true
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    @State private var isFillMode: Bool = false
    @State private var showToolbar: Bool = false
    @State private var dismissOffset: CGSize = .zero
    @State private var isDismissing: Bool = false
    @State private var magnification: CGFloat = 1.0
    @State private var lastMagnification: CGFloat = 1.0
    @State private var isZooming: Bool = false
    @State private var scrollViewOffset: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var deviceColorScheme
    @ObservedObject private var unsplashService = UnsplashService.shared
    
    init(
        attachments: [MediaAttachment],
        initialIndex: Int = 0,
        sourceID: String? = nil,
        namespace: Namespace.ID,
        sourceImage: Image? = nil
    ) {
        self.attachments = attachments
        self.initialIndex = initialIndex
        self.sourceID = sourceID
        self.namespace = namespace
        self.sourceImage = sourceImage
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background overlay
                (isDarkMode ? Color.black : Color.white)
                    .opacity(opacity)
                    .ignoresSafeArea()
                
                // ScrollView for horizontal pagination
                if attachments.count > 1 {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(Array(attachments.enumerated()), id: \.element.id) { index, attachment in
                                    singleImageLightboxView(attachment: attachment, geometry: geometry)
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .id(index)
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .onAppear {
                            // Scroll to initial index
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo(initialIndex, anchor: .center)
                                }
                            }
                        }
                        .onChange(of: currentIndex) { _, newIndex in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                    }
                } else if let attachment = attachments.first {
                    // Single image - use the same view as single attachment lightbox
                    singleImageLightboxView(attachment: attachment, geometry: geometry)
                }
                
                // Pagination dots - only show if more than one attachment
                if attachments.count > 1 {
                    paginationDots
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 100)
                }
            }
            .offset(dismissOffset)
            .gesture(
                SimultaneousGesture(
                    // Double tap to toggle between fit and fill modes
                    TapGesture(count: 2)
                        .onEnded {
                            handleDoubleTap()
                            if !isDarkMode {
                                showToolbarIfNeeded()
                            }
                        },
                    // Single tap to toggle dark mode and show/hide toolbar accordingly
                    TapGesture(count: 1)
                        .onEnded {
                            if !isFillMode {
                                if deviceColorScheme == .light {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isDarkMode.toggle()
                                    }
                                    showToolbar = !isDarkMode
                                } else {
                                    showToolbar.toggle()
                                }
                            } else {
                                showToolbar.toggle()
                            }
                        }
                )
            )
            .gesture(
                // Magnification gesture for pinch to zoom
                MagnificationGesture()
                    .onChanged { value in
                        handleMagnificationGesture(value)
                        if !isDarkMode {
                            showToolbarIfNeeded()
                        }
                    }
                    .onEnded { value in
                        handleMagnificationEnd(value)
                    }
            )
            .gesture(
                // Pan gesture when in fill mode or when zoomed
                (isFillMode || magnification > 1.0) ? DragGesture()
                    .onChanged { value in
                        handleDragGesture(value, in: geometry)
                        if !isDarkMode {
                            showToolbarIfNeeded()
                        }
                    }
                    .onEnded { value in
                        handleDragEnd(value, in: geometry)
                    } : nil
            )
            .onAppear {
                isAnimating = true
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    opacity = 1.0
                }
                
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
    
    // MARK: - Single Image Lightbox View
    @ViewBuilder
    private func singleImageLightboxView(attachment: MediaAttachment, geometry: GeometryProxy) -> some View {
        if attachment.type == .image {
            // Check if this is the initial attachment and we have a source image
            let isInitialAttachment = attachments.firstIndex(where: { $0.id == attachment.id }) == initialIndex
            
            if isInitialAttachment, let sourceImage = sourceImage {
                // Use the source image for the initial attachment to enable smooth transition
                sourceImage
                    .resizable()
                    .modifier(ImageScalingModifier(isFillMode: isFillMode, magnification: magnification))
            } else {
                // Use AsyncImage for other attachments
                AsyncImage(url: getImageURL(for: attachment)) { image in
                    image
                        .resizable()
                        .modifier(ImageScalingModifier(isFillMode: isFillMode, magnification: magnification))
                } placeholder: {
                    // Use a placeholder that matches the source image if available
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: isDarkMode ? .white : .black))
                                .scaleEffect(1.5)
                        )
                }
            }
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    Text("Unsupported attachment type")
                        .foregroundColor(isDarkMode ? .white : .black)
                )
        }
    }
    
    // MARK: - Pagination Dots
    private var paginationDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<attachments.count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.6))
        )
    }
    
    // MARK: - Helper Methods
    private func getImageURL(for attachment: MediaAttachment) -> URL? {
        guard let imageIndex = attachment.imageIndex,
              let photo = unsplashService.getPhoto(at: imageIndex) else {
            return nil
        }
        return URL(string: photo.urls.full)
    }
    
    // MARK: - ScrollView Change Handler
    private func updateCurrentIndex(from scrollOffset: CGFloat, screenWidth: CGFloat) {
        let newIndex = Int(round(scrollOffset / screenWidth))
        if newIndex != currentIndex && newIndex >= 0 && newIndex < attachments.count {
            currentIndex = newIndex
            // Reset zoom and pan when navigating
            magnification = 1.0
            lastMagnification = 1.0
            isFillMode = false
            panOffset = .zero
            lastPanOffset = .zero
        }
    }
    
    // MARK: - Reuse existing gesture handlers from LightboxView
    private func handleDoubleTap() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if !isFillMode && magnification == 1.0 && panOffset == .zero {
                panOffset = .zero
                lastPanOffset = .zero
                dismissOffset = .zero
                isDismissing = false
                isFillMode = true
                magnification = 1.0
                lastMagnification = 1.0
                isZooming = false
            } else {
                panOffset = .zero
                lastPanOffset = .zero
                dismissOffset = .zero
                isDismissing = false
                isFillMode = false
                magnification = 1.0
                lastMagnification = 1.0
                isZooming = false
            }
        }
    }
    
    private func showToolbarIfNeeded() {
        if (!isDarkMode || deviceColorScheme == .light) && !showToolbar {
            showToolbar = true
        }
    }
    
    private func handleMagnificationGesture(_ value: MagnificationGesture.Value) {
        isZooming = true
        magnification = lastMagnification * value
        magnification = min(max(magnification, 0.5), 5.0)
    }
    
    private func handleMagnificationEnd(_ value: MagnificationGesture.Value) {
        isZooming = false
        lastMagnification = magnification
        
        if magnification < 1.0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                magnification = 1.0
                lastMagnification = 1.0
                panOffset = .zero
                lastPanOffset = .zero
            }
        }
    }
    
    private func handleDragGesture(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let translation = value.translation
        let dismissThreshold: CGFloat = 50
        
        let effectiveMagnification = isFillMode ? max(magnification, 1.0) : magnification
        let scaledImageWidth = geometry.size.width * effectiveMagnification
        let scaledImageHeight = geometry.size.height * effectiveMagnification
        
        let horizontalOverflow = max(0, (scaledImageWidth - geometry.size.width) / 2)
        let verticalOverflow = max(0, (scaledImageHeight - geometry.size.height) / 2)
        
        if magnification > 1.0 {
            let newPanX = lastPanOffset.width + translation.width
            let newPanY = lastPanOffset.height + translation.height
            
            let constrainedPanX = min(horizontalOverflow, max(-horizontalOverflow, newPanX))
            let constrainedPanY = min(verticalOverflow, max(-verticalOverflow, newPanY))
            
            let hitHorizontalBoundary = abs(newPanX) >= horizontalOverflow
            let hitVerticalBoundary = abs(newPanY) >= verticalOverflow
            
            if (hitHorizontalBoundary || hitVerticalBoundary) && abs(translation.height) > dismissThreshold {
                isDismissing = true
                panOffset = CGSize(width: constrainedPanX, height: constrainedPanY)
                dismissOffset = CGSize(width: 0, height: translation.height)
            } else {
                panOffset = CGSize(width: constrainedPanX, height: constrainedPanY)
                dismissOffset = CGSize(width: 0, height: 0)
            }
        } else if isFillMode {
            let newPanX = lastPanOffset.width + translation.width
            let newDismissY = translation.height
            
            let constrainedPanX = min(horizontalOverflow, max(-horizontalOverflow, newPanX))
            
            let hitLeftBoundary = newPanX <= CGFloat(-horizontalOverflow) && translation.width < 0
            let hitRightBoundary = newPanX >= horizontalOverflow && translation.width > 0
            
            if hitLeftBoundary || hitRightBoundary {
                isDismissing = true
                let excessMovement = newPanX - constrainedPanX
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: excessMovement, height: newDismissY)
            } else if abs(newDismissY) > dismissThreshold {
                isDismissing = true
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: 0, height: newDismissY)
            } else {
                panOffset = CGSize(width: constrainedPanX, height: 0)
                dismissOffset = CGSize(width: 0, height: newDismissY)
            }
        } else {
            if abs(translation.height) > dismissThreshold {
                isDismissing = true
                dismissOffset = CGSize(width: 0, height: translation.height)
            } else {
                dismissOffset = CGSize(width: 0, height: translation.height)
            }
        }
    }
    
    private func handleDragEnd(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let dismissThreshold: CGFloat = 50
        let dismissVelocity: CGFloat = 500
        
        let dismissY = dismissOffset.height
        let dismissX = dismissOffset.width
        let velocityY = value.velocity.height
        let velocityX = value.velocity.width
        
        let shouldDismiss = isDismissing && (
            abs(dismissY) > dismissThreshold || 
            abs(dismissX) > dismissThreshold ||
            abs(velocityY) > dismissVelocity ||
            abs(velocityX) > dismissVelocity
        )
        
        if shouldDismiss {
            withAnimation(.easeInOut(duration: 0.3)) {
                opacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                dismissOffset = .zero
                isDismissing = false
            }
            lastPanOffset = panOffset
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
    
    /// Multi-attachment lightbox with pagination support
    func multiAttachmentLightboxNavigation(
        attachments: [MediaAttachment],
        initialIndex: Int = 0,
        sourceID: String,
        namespace: Namespace.ID,
        sourceImage: Image? = nil
    ) -> some View {
        MultiAttachmentLightboxNavigationLink(
            attachments: attachments,
            initialIndex: initialIndex,
            sourceID: sourceID,
            namespace: namespace,
            sourceImage: sourceImage
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
