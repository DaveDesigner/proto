# Message Composer Text Input Behavior & Formatting

## Overview
This PR explores and clarifies the message composer text input behavior, with a focus on text formatting capabilities.

## Goals
- [x] Analyze current text input behavior in message composer
- [x] Research and implement text formatting options (bold, italic, etc.)
- [ ] Improve user experience for text composition
- [ ] Ensure consistent behavior across different input states

## Areas to Explore
- Text formatting (bold, italic, underline, strikethrough)
- Markdown support
- Rich text editing capabilities
- Input validation and sanitization
- Keyboard shortcuts for formatting
- Copy/paste behavior with formatted text

## Implementation Notes

### Completed Features
- **Format Menu Integration**: Added a comprehensive format menu to the plus action in the message editor
  - Includes bold, italic, underline, and link formatting options
  - Menu items properly ordered for bottom-up display (Bold → Italic → Underline → Link)
  - Uses markdown-style syntax for text formatting
  - Integrated seamlessly with existing comment mode UI

### Remaining Work
- **Multi-line Text Editor Height**: Extend the message editor to dynamically adjust height for multiple lines of text
  - Goal: Extend the toolbar item group itself without custom solutions
  - Current implementation uses fixed height constraints
  - Need to explore native SwiftUI solutions for dynamic toolbar height

## Testing
- [x] Test formatting options in various scenarios
- [ ] Verify behavior with different text lengths
- [ ] Test keyboard shortcuts
- [ ] Validate copy/paste functionality
- [ ] Test multi-line text editor height adjustment

---
*This PR is for exploration and development purposes. Final implementation will be refined based on findings.*
