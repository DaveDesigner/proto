# Video Autoplay Implementation

This document explains the new video autoplay system implemented for the Proto app's feed. The system automatically plays videos when they become visible in the scroll view and pauses them when they scroll out of view.

## Overview

The autoplay system consists of several key components:

1. **FeedVideo** - Manages individual AVPlayer instances
2. **VisibilityReporter** - Tracks how much of each video is visible on screen
3. **AutoplayVideoPlayer** - SwiftUI component that integrates with visibility tracking
4. **FeedVideoManager** - Optional manager class for handling multiple videos
5. **Visibility tracking** - Preference key system for reporting visibility

## Key Features

- ✅ **Automatic play/pause** based on scroll position
- ✅ **Player reuse** - AVPlayer instances are reused efficiently
- ✅ **Muted autoplay** - Videos play muted by default (iOS best practice)
- ✅ **App lifecycle handling** - Pauses all videos when app goes to background
- ✅ **Visibility threshold** - Only plays videos that are 50%+ visible
- ✅ **Single video playback** - Only one video plays at a time
- ✅ **Auto-loop** - Videos loop automatically when they finish
- ✅ **Manual controls** - Tap to show/hide play/pause controls

## Implementation Details

### FeedVideo Class

```swift
final class FeedVideo: Identifiable, ObservableObject {
    let id = UUID()
    let videoName: String
    let player: AVPlayer
    @Published var isActive = false  // drives play/pause
    @Published var isPlaying = false // tracks actual playback state
    
    init(videoName: String, muted: Bool = true)
    func updatePlayback(active: Bool)
    func togglePlayback()
}
```

### Visibility Tracking

The system uses SwiftUI's `PreferenceKey` system to track visibility:

```swift
private struct VisibilityKey: PreferenceKey {
    static var defaultValue: [UUID: CGFloat] = [:]
    static func reduce(value: inout [UUID : CGFloat], nextValue: () -> [UUID : CGFloat]) {
        value.merge(nextValue(), uniquingStrategy: { $1 })
    }
}
```

### Autoplay Logic

```swift
private func updateActivePlayback() {
    let threshold: CGFloat = 0.5
    let best = visibility
        .filter { $0.value >= threshold }
        .max(by: { $0.value < $1.value })?.key
    
    for feedVideo in feedVideos {
        feedVideo.updatePlayback(active: feedVideo.id == best)
    }
}
```

## Usage Examples

### Basic Implementation

```swift
struct MyFeedView: View {
    @State private var feedVideos: [FeedVideo] = []
    @State private var visibility: [UUID: CGFloat] = [:]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(feedVideos) { feedVideo in
                    PostPreview(
                        // ... other parameters
                        feedVideo: feedVideo
                    )
                }
            }
            .onPreferenceChange(VisibilityKey.self) { vis in
                visibility = vis
                updateActivePlayback()
            }
        }
        .onAppear {
            setupFeedVideos()
        }
    }
    
    private func setupFeedVideos() {
        feedVideos = [
            FeedVideo(videoName: "video1", muted: true),
            FeedVideo(videoName: "video2", muted: true)
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

### Using FeedVideoManager

```swift
struct MyFeedView: View {
    @StateObject private var videoManager = FeedVideoManager()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(videoManager.feedVideos) { feedVideo in
                    PostPreview(
                        // ... other parameters
                        feedVideo: feedVideo
                    )
                }
            }
            .onPreferenceChange(VisibilityKey.self) { vis in
                videoManager.updateVisibility(vis)
            }
        }
        .onAppear {
            // Add videos to manager
            videoManager.addVideo(videoName: "video1")
            videoManager.addVideo(videoName: "video2")
        }
    }
}
```

## Integration with Existing Code

### PostPreview Updates

The `PostPreview` component now supports an optional `feedVideo` parameter:

```swift
PostPreview(
    authorName: "Author",
    spaceName: "Space",
    createdAt: Date(),
    postTitle: "Title",
    postDescription: "Description",
    feedVideo: feedVideo  // New parameter for autoplay
)
```

### Backward Compatibility

The system maintains backward compatibility. If no `feedVideo` is provided, it falls back to the original `VideoPlayerComponent`:

```swift
if let feedVideo = feedVideo {
    // Show autoplay video content
    AutoplayVideoPlayer.postVideo(feedVideo: feedVideo, enableControls: true)
} else if let postVideoName = postVideoName {
    // Show regular video content (fallback)
    VideoPlayerComponent.postVideo(videoName: postVideoName, enableControls: true, autoPlay: false)
}
```

## Performance Considerations

1. **Player Reuse**: AVPlayer instances are created once and reused
2. **Memory Management**: Proper cleanup in `deinit`
3. **Visibility Calculation**: Efficient geometry calculations
4. **Threshold-based Playback**: Only plays videos that are significantly visible

## Customization Options

### Adjusting Autoplay Threshold

```swift
private let autoplayThreshold: CGFloat = 0.5  // 50% visible
```

### Enabling/Disabling Controls

```swift
AutoplayVideoPlayer.postVideo(feedVideo: feedVideo, enableControls: true)
```

### Muted vs Unmuted Playback

```swift
FeedVideo(videoName: "video", muted: true)  // Muted (recommended)
FeedVideo(videoName: "video", muted: false) // Unmuted
```

## App Lifecycle Handling

The system automatically handles app lifecycle changes:

```swift
.onChange(of: scenePhase) { _, phase in
    let active = (phase == .active)
    if !active { 
        feedVideos.forEach { $0.updatePlayback(active: false) } 
    } else { 
        updateActivePlayback() 
    }
}
```

## Testing

To test the autoplay functionality:

1. Run the app and navigate to the Community tab
2. Scroll to the video post (second post in the feed)
3. Observe that the video automatically plays when it becomes visible
4. Scroll away and back to see it pause/play automatically
5. Test app backgrounding to ensure all videos pause

## Troubleshooting

### Video Not Playing
- Check that the video file exists in the bundle
- Verify the video name matches exactly (case-sensitive)
- Ensure the video format is supported (MP4 recommended)

### Performance Issues
- Monitor memory usage with multiple videos
- Consider reducing the number of simultaneous video players
- Check for proper cleanup in `deinit`

### Visibility Not Working
- Ensure `VisibilityReporter` is properly added to the view hierarchy
- Check that `onPreferenceChange(VisibilityKey.self)` is called
- Verify the visibility calculation logic

## Future Enhancements

Potential improvements for the autoplay system:

1. **Preloading**: Preload next video in sequence
2. **Quality Adaptation**: Adjust video quality based on network conditions
3. **Analytics**: Track video engagement metrics
4. **User Preferences**: Allow users to disable autoplay
5. **Network Awareness**: Pause autoplay on cellular networks
6. **Battery Optimization**: Reduce autoplay frequency on low battery

## Related Files

- `FeedVideoManager.swift` - Core autoplay implementation
- `PostPreview.swift` - Updated to support autoplay videos
- `CommunityTab.swift` - Example implementation
- `VideoPlayer.swift` - Original video player component (still used as fallback)

