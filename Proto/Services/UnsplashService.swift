//
//  UnsplashService.swift
//  Proto
//
//  Simple image service for placeholder images
//

import Foundation
import SwiftUI

class UnsplashService: ObservableObject {
    static let shared = UnsplashService()
    
    private init() {}
    
    /// Get information about the current image service
    func getAPIInfo() -> String {
        return """
        🖼️ Local Image Service:
        • Using local placeholder images
        • No external API dependencies
        • Fast and reliable loading
        """
    }
    
    /// Create a simple image view with local placeholder
    func createAsyncImage(width: Int = 400, height: Int = 300, searchTerm: String? = nil, @ViewBuilder content: @escaping (Image) -> some View) -> some View {
        LocalPlaceholderImage(width: width, height: height, searchTerm: searchTerm, content: content)
    }
}

// MARK: - Local Placeholder Image View
struct LocalPlaceholderImage<Content: View>: View {
    let width: Int
    let height: Int
    let searchTerm: String?
    let content: (Image) -> Content
    
    @State private var imageName: String = ""
    
    var body: some View {
        Group {
            if !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: CGFloat(width), height: CGFloat(height))
                    .clipped()
                    .cornerRadius(16)
                    .overlay(
                        content(Image(imageName))
                    )
            } else {
                loadingView
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private var loadingView: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.3))
            .frame(width: CGFloat(width), height: CGFloat(height))
            .overlay(
                VStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            )
    }
    
    private func loadImage() {
        // Select a random placeholder image based on search term or use default
        let placeholderImages = getPlaceholderImages(for: searchTerm)
        imageName = placeholderImages.randomElement() ?? "Post image from TinyPNG"
    }
    
    private func getPlaceholderImages(for searchTerm: String?) -> [String] {
        guard let searchTerm = searchTerm?.lowercased() else {
            return [
                "Post image from TinyPNG",
                "Feed Dark Image",
                "Feed Light Image"
            ]
        }
        
        // Return images based on search term
        switch searchTerm {
        case "nature", "landscape", "outdoor":
            return ["Post image from TinyPNG"]
        case "people", "portrait", "person":
            return ["Feed Dark Image"]
        case "abstract", "art", "design":
            return ["Feed Light Image"]
        default:
            return [
                "Post image from TinyPNG",
                "Feed Dark Image", 
                "Feed Light Image"
            ]
        }
    }
}

// MARK: - Debug View
struct UnsplashDebugView: View {
    @State private var apiInfo = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Image Service Debug")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(apiInfo)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("✅ Using local placeholder images")
                .font(.caption)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            apiInfo = UnsplashService.shared.getAPIInfo()
        }
    }
}