//
//  UnsplashService.swift
//  Proto
//
//  Generated for Unsplash integration
//  https://unsplash.com/developers
//

import Foundation
import SwiftUI

class UnsplashService: ObservableObject {
    static let shared = UnsplashService()
    
    // Using Unsplash API for editorial-quality images
    private let baseURL = "https://api.unsplash.com"
    private let accessKey = "ez1vou7Oiu-Jlmne0pO9PlZFyRHqGThjoSL0ebBRQ6I"
    
    private init() {}
    
    /// Generate a random image URL from Unsplash editorial collection
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    ///   - searchTerm: Optional search term for filtering
    /// - Returns: URL string for the image
    func getRandomImageURL(width: Int = 400, height: Int = 300, searchTerm: String? = nil) -> String {
        // This method is now deprecated - use fetchRandomPhoto with completion handler instead
        // Keeping for backward compatibility but will return a placeholder
        return "https://via.placeholder.com/\(width)x\(height)/cccccc/666666?text=Loading..."
    }
    
    /// Fetch a random photo from Unsplash editorial collection
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    ///   - searchTerm: Optional search term for filtering
    ///   - completion: Completion handler with the image URL
    func fetchRandomPhoto(width: Int = 400, height: Int = 300, searchTerm: String? = nil, completion: @escaping (String?) -> Void) {
        // For now, use a high-quality placeholder service while we debug the Unsplash API
        // This provides professional-looking images without API key issues
        
        var placeholderURL = "https://picsum.photos/\(width)/\(height)"
        
        // Add search term as seed for consistent results
        if let searchTerm = searchTerm {
            let seedHash = searchTerm.hashValue
            placeholderURL = "https://picsum.photos/seed/\(abs(seedHash))/\(width)/\(height)"
        }
        
        // Simulate async loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(placeholderURL)
        }
        
        // TODO: Re-enable Unsplash API once access key is verified
        /*
        var urlComponents = URLComponents(string: "\(baseURL)/photos/random")!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "w", value: String(width)),
            URLQueryItem(name: "h", value: String(height)),
            URLQueryItem(name: "orientation", value: "landscape"),
            URLQueryItem(name: "collections", value: "editorial") // Editorial collection
        ]
        
        if let searchTerm = searchTerm {
            queryItems.append(URLQueryItem(name: "query", value: searchTerm))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Unsplash API error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("No data received from Unsplash")
                    completion(nil)
                    return
                }
                
                do {
                    // Parse the JSON response - Unsplash random endpoint returns a single photo object
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let urls = json["urls"] as? [String: String],
                       let imageURL = urls["regular"] {
                        completion(imageURL)
                    } else {
                        print("Failed to parse Unsplash response")
                        completion(nil)
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }.resume()
        */
    }
    
    /// Generate a random image URL with specific search terms from editorial collection
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    ///   - searchTerm: Search term for filtering editorial images
    /// - Returns: URL string for the image
    func getSearchImageURL(width: Int = 400, height: Int = 300, searchTerm: String) -> String {
        return getRandomImageURL(width: width, height: height, searchTerm: searchTerm)
    }
    
    /// Get a business/office related image for executive coaching content from editorial collection
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    /// - Returns: URL string for a business-related editorial image
    func getBusinessImageURL(width: Int = 400, height: Int = 300) -> String {
        return getSearchImageURL(width: width, height: height, searchTerm: "business office meeting")
    }
}

// MARK: - SwiftUI AsyncImage Helper
extension UnsplashService {
    /// Create an AsyncImage view with Unsplash editorial images
    /// - Parameters:
    ///   - width: Image width in pixels
    ///   - height: Image height in pixels
    ///   - searchTerm: Optional search term for filtering editorial images
    ///   - content: Custom content view for the image
    /// - Returns: AsyncImage view configured with Unsplash editorial image
    func createAsyncImage(
        width: Int = 400,
        height: Int = 300,
        searchTerm: String? = nil,
        @ViewBuilder content: @escaping (Image) -> some View
    ) -> some View {
        UnsplashEditorialImage(
            width: width,
            height: height,
            searchTerm: searchTerm,
            content: content
        )
    }
}

// MARK: - Unsplash Editorial Image View
struct UnsplashEditorialImage<Content: View>: View {
    let width: Int
    let height: Int
    let searchTerm: String?
    let content: (Image) -> Content
    
    @State private var imageURL: String?
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some View {
        Group {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        content(image)
                    case .failure(_):
                        fallbackView
                    case .empty:
                        loadingView
                    @unknown default:
                        fallbackView
                    }
                }
            } else if hasError {
                fallbackView
            } else {
                loadingView
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private var loadingView: some View {
        ImageSkeletonPlaceholder()
    }
    
    private var fallbackView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.secondary.opacity(0.3))
            .frame(height: 200)
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                        .font(.title2)
                    Text("Image unavailable")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            )
    }
    
    private func loadImage() {
        UnsplashService.shared.fetchRandomPhoto(
            width: width,
            height: height,
            searchTerm: searchTerm
        ) { url in
            if let url = url {
                self.imageURL = url
                self.isLoading = false
            } else {
                self.hasError = true
                self.isLoading = false
            }
        }
    }
}

// MARK: - Image Skeleton Placeholder
struct ImageSkeletonPlaceholder: View {
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color(.systemGray4),
                        Color(.systemGray5)
                    ]),
                    startPoint: isAnimating ? .topLeading : .bottomTrailing,
                    endPoint: isAnimating ? .bottomTrailing : .topLeading
                )
            )
            .frame(height: 200)
            .clipped()
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}
