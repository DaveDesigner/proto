//
//  VideoPlayer.swift
//  Proto
//
//  Video player component using AVKit for native video playback
//  https://developer.apple.com/documentation/avkit
//

import SwiftUI
import AVKit
import AVFoundation

struct VideoPlayerComponent: View {
    let videoName: String
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let enableControls: Bool
    let autoPlay: Bool
    
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showControls = false
    
    init(
        videoName: String,
        width: CGFloat = 400,
        height: CGFloat = 250,
        cornerRadius: CGFloat = 12,
        enableControls: Bool = true,
        autoPlay: Bool = false
    ) {
        self.videoName = videoName
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.enableControls = enableControls
        self.autoPlay = autoPlay
    }
    
    var body: some View {
        ZStack {
            // Video player
            if let player = player {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity, maxHeight: height)
                    .aspectRatio(16/9, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .onTapGesture {
                        if enableControls {
                            showControls.toggle()
                        }
                    }
                    .onAppear {
                        if autoPlay {
                            player.play()
                            isPlaying = true
                        }
                    }
            } else {
                // Loading state
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: height)
                    .aspectRatio(16/9, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Loading video...")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    )
            }
            
            // Custom overlay controls (optional)
            if showControls && enableControls {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            if isPlaying {
                                player?.pause()
                            } else {
                                player?.play()
                            }
                            isPlaying.toggle()
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
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
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    private func setupPlayer() {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Error: Could not find video file: \(videoName).mp4")
            return
        }
        
        player = AVPlayer(url: url)
        
        // Add observer for playback status
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            isPlaying = false
            player?.seek(to: .zero)
        }
    }
}

// MARK: - Convenience Initializers
extension VideoPlayerComponent {
    /// Create a video component for post previews
    static func postVideo(videoName: String, enableControls: Bool = true, autoPlay: Bool = false) -> VideoPlayerComponent {
        VideoPlayerComponent(
            videoName: videoName,
            width: .infinity, // Will be constrained by maxWidth: .infinity
            height: 250,
            cornerRadius: 12,
            enableControls: enableControls,
            autoPlay: autoPlay
        )
    }
    
    /// Create a video component for feed videos
    static func feedVideo(videoName: String, enableControls: Bool = true, autoPlay: Bool = false) -> VideoPlayerComponent {
        VideoPlayerComponent(
            videoName: videoName,
            width: .infinity, // Will be constrained by maxWidth: .infinity
            height: 300,
            cornerRadius: 16,
            enableControls: enableControls,
            autoPlay: autoPlay
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        VideoPlayerComponent.postVideo(videoName: "What is Circle", enableControls: true)
        
        VideoPlayerComponent.feedVideo(videoName: "What is Circle", enableControls: true, autoPlay: false)
    }
    .padding()
}
