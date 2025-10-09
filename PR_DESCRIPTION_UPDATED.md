# 🎥 Video Autoplay Feature

## Summary

This PR adds auto-playing video functionality to the feed. Videos automatically play when they become visible in the scroll view and pause when they scroll out of view.

## What Was Implemented

### ✅ Video Autoplay System
- **Automatic play/pause** based on scroll position and visibility
- **Single video playback** - only one video plays at a time
- **Muted autoplay** - videos play muted by default (iOS best practice)
- **Visibility threshold** - only plays videos that are 50%+ visible
- **App lifecycle handling** - pauses all videos when app goes to background
- **Auto-loop** - videos loop automatically when they finish

### 🎯 Core Components Added
- `FeedVideoManager.swift` - Manages AVPlayer instances and autoplay logic
- `FeedVideo` class - Individual video player with playback state management
- `AutoplayVideoPlayer` - SwiftUI component for autoplay video display
- `VisibilityReporter` - Tracks video visibility in scroll view

### 🔄 Files Modified
- `PostPreview.swift` - Added support for autoplay videos
- `VideoPlayer.swift` - Updated for compatibility
- `CommunityTab.swift` - Integrated autoplay system into feed

## Technical Details

The system uses SwiftUI's `PreferenceKey` system to track which videos are visible on screen. When a video becomes 50%+ visible, it automatically starts playing. Only one video plays at a time, and videos pause when scrolling away.

## Testing

1. Navigate to Community tab
2. Scroll to the video post (second post in feed)
3. Video automatically plays when visible
4. Scroll away and back to see pause/play behavior
5. Test app backgrounding - all videos should pause

## Files Added
- `Proto/Views/Components/Content/FeedVideoManager.swift` - Core autoplay implementation
- `Proto/Views/Components/Content/FeedVideoManagerPreview.swift` - Preview component

## Files Modified
- `Proto/Views/Components/Content/PostPreview.swift` - Added autoplay support
- `Proto/Views/Components/Content/VideoPlayer.swift` - Updated compatibility
- `Proto/Views/Tabs/CommunityTab.swift` - Integrated autoplay system