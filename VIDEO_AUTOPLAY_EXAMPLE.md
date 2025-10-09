# Video Autoplay Example Usage

This document provides practical examples of how to use the new video autoplay system in your Proto app.

## Quick Start Example

Here's a minimal example of implementing autoplay in a feed:

```swift
import SwiftUI

struct SimpleAutoplayFeed: View {
    @State private var feedVideos: [FeedVideo] = []
    @State private var visibility: [UUID: CGFloat] = [:]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(feedVideos) { feedVideo in
                    VStack {
                        Text("Video: \(feedVideo.videoName)")
                            .font(.headline)
                        
                        AutoplayVideoPlayer.feedVideo(feedVideo: feedVideo)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
            .onPreferenceChange(VisibilityKey.self) { vis in
                visibility = vis
                updateActivePlayback()
            }
        }
        .onAppear {
            setupVideos()
        }
    }
    
    private func setupVideos() {
        feedVideos = [
            FeedVideo(videoName: "What is Circle", muted: true),
            // Add more videos here as needed
        ]
    }
    
    private func updateActivePlayback() {
        let threshold: CGFloat = 0.5
        let best = visibility
            .filter { $0.value >= threshold }
            .max(by: { $0.value < $1.value })?.key
        
        for feedVideo in feedVideos {
            feedVideo.updatePlayback(active: feedVideo.id == best)
        }
    }
}
```

## Adding Multiple Videos to CommunityTab

To add more videos to your existing CommunityTab, update the `setupFeedVideos()` method:

```swift
private func setupFeedVideos() {
    feedVideos = [
        FeedVideo(videoName: "What is Circle", muted: true),
        FeedVideo(videoName: "Another Video", muted: true),
        FeedVideo(videoName: "Third Video", muted: true)
    ]
}
```

Then update your PostPreview calls to use the corresponding FeedVideo:

```swift
// For the second video post
PostPreview(
    // ... other parameters
    feedVideo: feedVideos.first { $0.videoName == "Another Video" }
)

// For the third video post  
PostPreview(
    // ... other parameters
    feedVideo: feedVideos.first { $0.videoName == "Third Video" }
)
```

## Using FeedVideoManager for Complex Feeds

For feeds with many videos, use the `FeedVideoManager`:

```swift
struct AdvancedFeedView: View {
    @StateObject private var videoManager = FeedVideoManager()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(videoManager.feedVideos) { feedVideo in
                    PostPreview(
                        authorName: "Author",
                        spaceName: "Space", 
                        createdAt: Date(),
                        postTitle: "Title",
                        postDescription: "Description",
                        feedVideo: feedVideo
                    )
                }
            }
            .onPreferenceChange(VisibilityKey.self) { vis in
                videoManager.updateVisibility(vis)
            }
        }
        .onAppear {
            setupVideos()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase != .active {
                videoManager.pauseAllVideos()
            } else {
                videoManager.resumeAutoplay()
            }
        }
    }
    
    private func setupVideos() {
        // Add videos dynamically
        videoManager.addVideo(videoName: "video1")
        videoManager.addVideo(videoName: "video2") 
        videoManager.addVideo(videoName: "video3")
    }
}
```

## Customizing Autoplay Behavior

### Adjusting Visibility Threshold

```swift
// More sensitive - plays when 30% visible
private let autoplayThreshold: CGFloat = 0.3

// Less sensitive - plays when 70% visible  
private let autoplayThreshold: CGFloat = 0.7
```

### Enabling Unmuted Autoplay

```swift
// Muted autoplay (recommended for feeds)
FeedVideo(videoName: "video", muted: true)

// Unmuted autoplay (use sparingly)
FeedVideo(videoName: "video", muted: false)
```

### Disabling Controls

```swift
// No manual controls
AutoplayVideoPlayer.postVideo(feedVideo: feedVideo, enableControls: false)

// With manual controls (default)
AutoplayVideoPlayer.postVideo(feedVideo: feedVideo, enableControls: true)
```

## Testing Your Implementation

1. **Basic Functionality**:
   - Scroll to a video post
   - Verify it plays automatically when visible
   - Scroll away and back to test pause/play

2. **Multiple Videos**:
   - Add multiple video posts
   - Verify only one plays at a time
   - Test scrolling between videos

3. **App Lifecycle**:
   - Background the app while video is playing
   - Verify video pauses
   - Return to app and verify autoplay resumes

4. **Performance**:
   - Monitor memory usage
   - Check for smooth scrolling
   - Verify no memory leaks

## Common Patterns

### Lazy Loading Videos

```swift
private func loadVideosAsNeeded() {
    // Only create FeedVideo when post becomes visible
    if feedVideos.isEmpty {
        feedVideos = createVideosForVisiblePosts()
    }
}
```

### Video Preloading

```swift
private func preloadNextVideo() {
    // Preload the next video in sequence
    if let nextVideoName = getNextVideoName() {
        let preloadedVideo = FeedVideo(videoName: nextVideoName, muted: true)
        // Don't add to active feedVideos array yet
    }
}
```

### Conditional Autoplay

```swift
private func shouldAutoplay() -> Bool {
    // Check user preferences, network conditions, etc.
    return UserDefaults.standard.bool(forKey: "autoplayEnabled") && 
           !isOnCellularNetwork()
}
```

## Troubleshooting Tips

1. **Video not found**: Check file name and extension match exactly
2. **No autoplay**: Verify `VisibilityReporter` is in the view hierarchy
3. **Multiple videos playing**: Check that only one video has `isActive = true`
4. **Memory issues**: Ensure proper cleanup in `deinit`
5. **Performance**: Consider reducing video quality or number of simultaneous players

## Best Practices

1. **Use muted autoplay** for better user experience
2. **Limit concurrent videos** to 2-3 maximum
3. **Handle app lifecycle** properly (pause on background)
4. **Provide manual controls** for user control
5. **Test on different devices** and network conditions
6. **Monitor performance** and memory usage
7. **Respect user preferences** for autoplay settings

