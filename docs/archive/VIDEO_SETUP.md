# Video Demo Setup

## Video File Required

To test the video demo functionality, you need to add the video file to your project:

1. **File Location**: `Proto/Resources/What is Circle.mp4`
2. **File Size**: ~11MB (excluded from Git due to size)
3. **Format**: MP4 video file

## Adding the Video File

1. Download or obtain the "What is Circle.mp4" video file
2. Place it in the `Proto/Resources/` directory
3. The Xcode project will automatically include it via `fileSystemSynchronizedGroups`

## Video Player Features

The video player component includes:

- **Native AVKit Integration**: Uses Apple's AVKit framework for optimal performance
- **Custom Controls**: Tap to show/hide play/pause controls
- **Loading States**: Proper loading indicators while video loads
- **Error Handling**: Graceful fallback if video file is missing
- **Responsive Design**: Adapts to different screen sizes

## Implementation Details

- **Component**: `VideoPlayerComponent` in `Proto/Views/Components/Content/VideoPlayer.swift`
- **Integration**: Updated `PostPreview` to support both images and videos
- **Demo Usage**: Second post in Community feed shows the video instead of an image

## Testing

1. Ensure the video file is in the correct location
2. Run the app and navigate to Community tab
3. The second post should display the video player
4. Tap the video to show controls and test play/pause functionality

## AVKit Documentation

For more information about AVKit implementation:
https://developer.apple.com/documentation/avkit
