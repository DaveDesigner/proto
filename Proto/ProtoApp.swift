//
//  ProtoApp.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

@main
struct ProtoApp: App {
    // Initialize UnsplashService early to start loading photos
    private let unsplashService = UnsplashService.shared
    
    init() {
        print("🚀 ProtoApp: Initializing app with UnsplashService")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.primary) // Override global accent color to use primary color
        }
    }
}