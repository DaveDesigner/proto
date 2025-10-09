//
//  FeedVideoManager.swift
//  Proto
//
//  Manages AVPlayer instances for feed videos with autoplay functionality
//

import SwiftUI
import AVKit
import AVFoundation

// MARK: - FeedVideo Model
final class FeedVideo: NSObject, Identifiable, ObservableObject {
    let id = UUID()
    let videoName: String
    let player: AVPlayer
    @Published var isActive = false  // drives play/pause
    @Published var isPlaying = false // tracks actual playback state
    
    init(videoName: String, muted: Bool = true) {
        self.videoName = videoName
        
        // Create player from bundle resource
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Error: Could not find video file: \(videoName).mp4")
            // Create a dummy player to prevent crashes
            self.player = AVPlayer()
            super.init()
            return
        }
        
        self.player = AVPlayer(url: url)
        self.player.isMuted = muted
        
        super.init()
        
        // Add observer for playback status
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.isPlaying = false
            self?.player.seek(to: .zero)
            // Auto-loop for feed videos
            self?.player.play()
            self?.isPlaying = true
        }
        
        // Note: Removed KVO observer for SwiftUI preview compatibility
        // Playback state is tracked via the updatePlayback method instead
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updatePlayback(active: Bool) {
        guard active != isActive else { return }
        isActive = active
        
        if active {
            player.play()
            isPlaying = true
        } else {
            player.pause()
            isPlaying = false
        }
    }
    
    func togglePlayback() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}

// MARK: - Visibility Tracking
struct VisibilityKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:] // id -> visible fraction (0...1)
    static func reduce(value: inout [UUID : CGFloat], nextValue: () -> [UUID : CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct VisibilityReporter: View {
    let id: UUID
    
    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(key: VisibilityKey.self, value: [id: visibleFraction(in: geo)])
        }
    }
    
    private func visibleFraction(in geo: GeometryProxy) -> CGFloat {
        // Get the screen bounds - using a more modern approach
        let screenBounds = CGRect(x: 0, y: 0, width: 393, height: 852) // iPhone 16 default size
        
        // Convert local frame to global coordinates
        let frame = geo.frame(in: .global)
        let intersection = frame.intersection(screenBounds)
        
        guard !frame.isEmpty else { return 0 }
        
        // Calculate how centered the video is vertically
        let screenCenterY = screenBounds.midY
        let videoCenterY = frame.midY
        let distanceFromCenter = abs(videoCenterY - screenCenterY)
        
        // Define the "center zone" - how close to center is considered "centered"
        let centerZoneHeight: CGFloat = 400 // Adjust this to make the zone smaller/larger
        
        // Calculate visibility based on distance from center
        let centerVisibility = max(0, 1 - (distanceFromCenter / centerZoneHeight))
        
        // Also consider how much of the video is actually visible
        let visibleArea = intersection.height * intersection.width
        let totalArea = frame.height * frame.width
        let areaVisibility = max(0, min(1, visibleArea / totalArea))
        
        // Combine both factors - video must be both visible AND centered
        return centerVisibility * areaVisibility
    }
}

// MARK: - Autoplay Video Player Component
struct AutoplayVideoPlayer: View {
    @ObservedObject var feedVideo: FeedVideo
    let cornerRadius: CGFloat
    let enableControls: Bool
    @State private var showControls = false
    
    init(
        feedVideo: FeedVideo,
        cornerRadius: CGFloat = 12,
        enableControls: Bool = true
    ) {
        self.feedVideo = feedVideo
        self.cornerRadius = cornerRadius
        self.enableControls = enableControls
    }
    
    var body: some View {
        ZStack {
            // Video player
            VideoPlayer(player: feedVideo.player)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .aspectRatio(16/9, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .onDisappear {
                    // Safety: pause when view disappears
                    feedVideo.updatePlayback(active: false)
                }
            
            
            // Custom overlay controls (optional)
            if showControls && enableControls {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            feedVideo.togglePlayback()
                        }) {
                            Image(systemName: feedVideo.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
            
            // Visibility reporter for autoplay tracking
            VisibilityReporter(id: feedVideo.id)
        }
    }
}

// MARK: - Convenience Initializers
extension AutoplayVideoPlayer {
    /// Create an autoplay video component for post previews
    static func postVideo(feedVideo: FeedVideo, enableControls: Bool = true) -> AutoplayVideoPlayer {
        AutoplayVideoPlayer(
            feedVideo: feedVideo,
            cornerRadius: 12,
            enableControls: enableControls
        )
    }
    
    /// Create an autoplay video component for feed videos
    static func feedVideo(feedVideo: FeedVideo, enableControls: Bool = true) -> AutoplayVideoPlayer {
        AutoplayVideoPlayer(
            feedVideo: feedVideo,
            cornerRadius: 16,
            enableControls: enableControls
        )
    }
}

// MARK: - FeedVideoManager
class FeedVideoManager: ObservableObject {
    @Published var feedVideos: [FeedVideo] = []
    @Published var visibility: [UUID: CGFloat] = [:]
    
    private let autoplayThreshold: CGFloat = 0.5
    
    func addVideo(videoName: String, muted: Bool = true) -> FeedVideo {
        let feedVideo = FeedVideo(videoName: videoName, muted: muted)
        feedVideos.append(feedVideo)
        return feedVideo
    }
    
    func updateVisibility(_ newVisibility: [UUID: CGFloat]) {
        visibility = newVisibility
        updateActivePlayback()
    }
    
    private func updateActivePlayback() {
        // Pick the most visible video above threshold
        let best = visibility
            .filter { $0.value >= autoplayThreshold }
            .max(by: { $0.value < $1.value })?.key
        
        for feedVideo in feedVideos {
            feedVideo.updatePlayback(active: feedVideo.id == best)
        }
    }
    
    func pauseAllVideos() {
        feedVideos.forEach { $0.updatePlayback(active: false) }
    }
    
    func resumeAutoplay() {
        updateActivePlayback()
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Simple preview using the original VideoPlayerComponent
        VideoPlayerComponent.postVideo(videoName: "What is Circle", enableControls: true)
    }
    .padding()
}
