//
//  UnsplashService.swift
//  Proto
//
//  Unsplash API service for fetching featured images
//

import Foundation
import SwiftUI

// MARK: - Data Models
struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let urls: UnsplashPhotoURLs
    let user: UnsplashUser
    let description: String?
    let altDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, urls, user, description
        case altDescription = "alt_description"
    }
}

struct UnsplashPhotoURLs: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct UnsplashUser: Codable {
    let id: String
    let username: String
    let name: String
    let profileImage: UnsplashUserProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
    }
}

struct UnsplashUserProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

// MARK: - Unsplash Service
class UnsplashService: ObservableObject {
    static let shared = UnsplashService()
    
    @Published var featuredPhotos: [UnsplashPhoto] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    // Session ID for cache-busting - generated once per app launch
    let sessionId: String
    
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = "rvF-wl7RcIsygQqBTDx6CD-3mMoigi6KB48U7xsqmkM"
    private let featuredEndpoint = "/photos"
    
    private init() {
        // Generate a unique session ID for this app launch
        self.sessionId = UUID().uuidString
        loadFeaturedPhotos()
    }
    
    /// Get information about the current image service
    func getAPIInfo() -> String {
        return """
        🖼️ Unsplash API Service:
        • Fetching featured images from Unsplash
        • Dynamic content loading
        • Real-time image updates
        • \(featuredPhotos.count) photos loaded
        """
    }
    
    /// Load featured photos from Unsplash API
    func loadFeaturedPhotos() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "\(baseURL)\(featuredEndpoint)?per_page=30&order_by=latest") else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.error = "No data received"
                    return
                }
                
                do {
                    let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                    self?.featuredPhotos = photos
                    // Reset the image counter when new photos are loaded
                    PostPreview.resetImageCounter()
                } catch {
                    self?.error = "Failed to decode photos: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    /// Get a photo by index (for sequential assignment)
    func getPhoto(at index: Int) -> UnsplashPhoto? {
        guard !featuredPhotos.isEmpty else { 
            return nil 
        }
        let photo = featuredPhotos[index % featuredPhotos.count]
        return photo
    }
    
    /// Create a dynamic image view using Unsplash photos with lightbox support
    func createAsyncImage(width: Int? = 400, height: Int? = 300, imageIndex: Int = 0, enableLightbox: Bool = true, @ViewBuilder content: @escaping (Image) -> some View) -> some View {
        if let photo = getPhoto(at: imageIndex) {
            return AnyView(
                UnsplashImageView(
                    photo: photo,
                    width: width,
                    height: height,
                    enableLightbox: enableLightbox,
                    content: content
                )
            )
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange.opacity(0.3))
                    .frame(maxWidth: width != nil ? CGFloat(width!) : .infinity)
                    .frame(height: height != nil ? CGFloat(height!) : nil)
                    .overlay(
                        Text("No photo at index \(imageIndex)")
                            .foregroundColor(.orange)
                    )
            )
        }
    }
    
    /// Create a post image using the convenience method
    func createPostImage(imageIndex: Int = 0, enableLightbox: Bool = true) -> some View {
        createAsyncImage(width: nil, height: nil, imageIndex: imageIndex, enableLightbox: enableLightbox) { image in
            EmptyView()
        }
    }
    
    /// Create a feed image using the convenience method
    func createFeedImage(imageIndex: Int = 0, enableLightbox: Bool = true) -> some View {
        createAsyncImage(width: 400, height: 300, imageIndex: imageIndex, enableLightbox: enableLightbox) { image in
            EmptyView()
        }
    }
}

// MARK: - Debug View
struct UnsplashDebugView: View {
    @StateObject private var unsplashService = UnsplashService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Unsplash API Debug")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(unsplashService.getAPIInfo())
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            if unsplashService.isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading photos...")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            } else if let error = unsplashService.error {
                Text("❌ Error: \(error)")
                    .font(.caption)
                    .foregroundColor(.red)
            } else if !unsplashService.featuredPhotos.isEmpty {
                Text("✅ \(unsplashService.featuredPhotos.count) photos loaded")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Unsplash Image View with Lightbox Support
struct UnsplashImageView: View {
    let photo: UnsplashPhoto
    let width: Int?
    let height: Int?
    let enableLightbox: Bool
    let content: (Image) -> AnyView
    
    @State private var loadedImage: Image?
    @Namespace private var animationNamespace
    
    init(
        photo: UnsplashPhoto,
        width: Int? = nil,
        height: Int? = nil,
        enableLightbox: Bool = true,
        @ViewBuilder content: @escaping (Image) -> some View
    ) {
        self.photo = photo
        self.width = width
        self.height = height
        self.enableLightbox = enableLightbox
        self.content = { AnyView(content($0)) }
    }
    
    var body: some View {
        AsyncImage(url: URL(string: photo.urls.regular)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: width != nil ? CGFloat(width!) : .infinity)
                    .frame(height: height != nil ? CGFloat(height!) : nil)
                    .clipped()
                    .cornerRadius(16)
                    .overlay(
                        content(image)
                    )
                    .matchedTransitionSource(
                        id: "unsplash-\(photo.id)",
                        in: animationNamespace
                    )
                    .lightboxNavigation(
                        imageURL: URL(string: photo.urls.full),
                        sourceImage: image,
                        sourceID: "unsplash-\(photo.id)",
                        namespace: animationNamespace
                    )
            case .failure(let error):
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red.opacity(0.3))
                    .frame(maxWidth: width != nil ? CGFloat(width!) : .infinity)
                    .frame(height: height != nil ? CGFloat(height!) : nil)
                    .overlay(
                        VStack {
                            Text("❌ Failed to load")
                                .font(.caption)
                                .foregroundColor(.red)
                            Text("Photo: \(photo.id)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    )
            case .empty:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: width != nil ? CGFloat(width!) : .infinity)
                    .frame(height: height != nil ? CGFloat(height!) : nil)
                    .overlay(
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Text("Loading...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    )
            @unknown default:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.orange.opacity(0.3))
                    .frame(maxWidth: width != nil ? CGFloat(width!) : .infinity)
                    .frame(height: height != nil ? CGFloat(height!) : nil)
                    .overlay(
                        Text("Unknown state")
                            .font(.caption)
                            .foregroundColor(.orange)
                    )
            }
        }
    }
}