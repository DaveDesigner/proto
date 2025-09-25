//
//  LightboxView.swift
//  Proto
//
//  Lightbox component for expanding and collapsing images with smooth animations
//

import SwiftUI

struct LightboxView: View {
    let imageName: String
    let isPresented: Binding<Bool>
    let onDismiss: (() -> Void)?
    
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    init(
        imageName: String,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil
    ) {
        self.imageName = imageName
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
                Image(imageName)
                    .resizable()
                    .scaledToFit()
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

// MARK: - Lightbox Modifier
struct LightboxModifier: ViewModifier {
    @Binding var isPresented: Bool
    let imageName: String
    let onDismiss: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                LightboxView(
                    imageName: imageName,
                    isPresented: $isPresented,
                    onDismiss: onDismiss
                )
                .transition(.opacity)
                .zIndex(1000)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func lightbox(
        isPresented: Binding<Bool>,
        imageName: String,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            LightboxModifier(
                isPresented: isPresented,
                imageName: imageName,
                onDismiss: onDismiss
            )
        )
    }
}

// MARK: - Preview
#Preview {
    struct LightboxPreview: View {
        @State private var showLightbox = false
        
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
                    .onTapGesture {
                        showLightbox = true
                    }
                    .lightbox(
                        isPresented: $showLightbox,
                        imageName: "Post"
                    )
                
                Button("Show Lightbox") {
                    showLightbox = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
    
    return LightboxPreview()
}
