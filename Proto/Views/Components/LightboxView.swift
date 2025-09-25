//
//  LightboxView.swift
//  Proto
//
//  Lightbox component for expanding and collapsing images with smooth animations
//

import SwiftUI

// MARK: - Global Lightbox Manager
class LightboxManager: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var imageName: String?
    @Published var imageURL: URL?
    
    func present(imageName: String? = nil, imageURL: URL? = nil) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.isPresented = true
    }
    
    func dismiss() {
        self.isPresented = false
        self.imageName = nil
        self.imageURL = nil
    }
}

// MARK: - Global Lightbox Overlay
struct GlobalLightboxOverlay: View {
    @StateObject private var lightboxManager = LightboxManager.shared
    
    var body: some View {
        ZStack {
            if lightboxManager.isPresented {
                LightboxView(
                    imageName: lightboxManager.imageName,
                    imageURL: lightboxManager.imageURL,
                    isPresented: $lightboxManager.isPresented,
                    onDismiss: {
                        lightboxManager.dismiss()
                    }
                )
                .transition(.opacity)
                .zIndex(9999) // Highest z-index
            }
        }
    }
}

// MARK: - Lightbox Manager Extension
extension LightboxManager {
    static let shared = LightboxManager()
}

struct LightboxView: View {
    let imageName: String?
    let imageURL: URL?
    let isPresented: Binding<Bool>
    let onDismiss: (() -> Void)?
    
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    init(
        imageName: String? = nil,
        imageURL: URL? = nil,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil
    ) {
        self.imageName = imageName
        self.imageURL = imageURL
        self.isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black
                .opacity(opacity)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissLightbox()
                }
            
            // Image content
            if isPresented.wrappedValue {
                Group {
                    if let imageName = imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                    } else if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Text("No image")
                                    .foregroundColor(.white)
                            )
                    }
                }
                .scaleEffect(scale)
                .offset(dragOffset)
                    .gesture(
                        SimultaneousGesture(
                            // Drag gesture for panning
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    // If dragged far enough, dismiss
                                    if abs(value.translation.height) > 100 {
                                        dismissLightbox()
                                    } else {
                                        // Snap back to center
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            dragOffset = .zero
                                        }
                                    }
                                },
                            
                            // Magnification gesture for zooming
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(0.5, min(value, 3.0))
                                }
                                .onEnded { _ in
                                    if scale < 0.8 {
                                        dismissLightbox()
                                    } else if scale > 2.5 {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            scale = 2.5
                                        }
                                    } else if scale < 1.0 {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            scale = 1.0
                                        }
                                    }
                                }
                        )
                    )
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            opacity = 1.0
                        }
                    }
            }
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismissLightbox()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
    }
    
    private func dismissLightbox() {
        withAnimation(.easeInOut(duration: 0.3)) {
            opacity = 0.0
            scale = 0.8
            dragOffset = .zero
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented.wrappedValue = false
            onDismiss?()
        }
    }
}


// MARK: - View Extension
extension View {
    func lightbox(
        imageName: String? = nil,
        imageURL: URL? = nil
    ) -> some View {
        self.onTapGesture {
            LightboxManager.shared.present(imageName: imageName, imageURL: imageURL)
        }
    }
}

// MARK: - Preview
#Preview {
    struct LightboxPreview: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("Tap the image to open lightbox")
                    .font(.headline)
                
                Image("Post")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 150)
                    .clipped()
                    .cornerRadius(12)
                    .lightbox(imageName: "Post")
                
                Button("Show Lightbox") {
                    LightboxManager.shared.present(imageName: "Post")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .overlay(GlobalLightboxOverlay())
        }
    }
    
    return LightboxPreview()
}
