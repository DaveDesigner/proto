# 📍 Video Autoplay Scroll Position Configuration

## 🎯 **Current Configuration**

The video autoplay system now uses **center-focused positioning** instead of simple visibility percentage. Here's how it works:

### **1. Center Zone Calculation** 
**File:** `FeedVideoManager.swift` → `visibleFraction(in:)` function

```swift
// Define the "center zone" - how close to center is considered "centered"
let centerZoneHeight: CGFloat = 200 // Adjust this to make the zone smaller/larger

// Calculate how centered the video is vertically
let screenCenterY = screenBounds.midY
let videoCenterY = frame.midY
let distanceFromCenter = abs(videoCenterY - screenCenterY)

// Calculate visibility based on distance from center
let centerVisibility = max(0, 1 - (distanceFromCenter / centerZoneHeight))
```

### **2. Autoplay Threshold**
**File:** `CommunityTab.swift` → `updateActivePlayback()` function

```swift
// Higher threshold = more centered video required to play
let threshold: CGFloat = 0.7 // Increased from 0.5 to 0.7 for more centered playback
```

## ⚙️ **How to Adjust the Settings**

### **Make the Center Zone Smaller (More Precise)**
```swift
let centerZoneHeight: CGFloat = 100 // Smaller = more precise centering required
```

### **Make the Center Zone Larger (More Forgiving)**
```swift
let centerZoneHeight: CGFloat = 300 // Larger = easier to trigger autoplay
```

### **Make Autoplay More Strict**
```swift
let threshold: CGFloat = 0.8 // Higher = more centered video required
```

### **Make Autoplay More Permissive**
```swift
let threshold: CGFloat = 0.5 // Lower = easier to trigger autoplay
```

## 📊 **Current Behavior**

With the current settings:
- **Center Zone:** 200 pixels from screen center
- **Threshold:** 0.7 (70% visibility score required)
- **Result:** Video only plays when it's within ~100 pixels of the vertical center of the screen

## 🎮 **Testing the Changes**

1. **Build and run** the app in the simulator
2. **Navigate to Community tab**
3. **Scroll slowly** through the feed
4. **Observe:** Video should only start playing when it's near the center of the screen
5. **Adjust settings** as needed based on your preference

## 🔧 **Fine-Tuning Recommendations**

### **For Very Precise Centering:**
```swift
let centerZoneHeight: CGFloat = 80
let threshold: CGFloat = 0.8
```

### **For Balanced Behavior:**
```swift
let centerZoneHeight: CGFloat = 150
let threshold: CGFloat = 0.6
```

### **For More Forgiving Autoplay:**
```swift
let centerZoneHeight: CGFloat = 250
let threshold: CGFloat = 0.5
```

## 📱 **Screen Dimensions Reference**

- **iPhone 16:** 393 × 852 pixels
- **Screen Center Y:** 426 pixels from top
- **Current Center Zone:** 200 pixels (100 pixels above/below center)

The system now prioritizes videos that are **vertically centered** on the screen rather than just "visible", giving you much more precise control over when autoplay triggers.

