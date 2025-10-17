# Proto - Project Memory

**Claude Code Persistent Memory Document**
*Last Updated: 2025-10-16*

---

## Development Best Practices

### SwiftUI Development
1. **Always prefer SwiftUI APIs native to iOS 18/26** before creating custom solutions
2. Use modern iOS 18+ patterns: NavigationStack, TabView with native tabs, Sheet detents, Liquid Glass materials
3. Leverage iOS 26 features when available: `.glassEffect()`, `.sharedBackgroundVisibility()`

### Development Workflow

**Build & Test Before Completing Tasks**
- **CRITICAL**: Always run the app in iPhone 16 Simulator **with iOS 26** before marking a task/todo as complete
- **Simulator Configuration**: Use `iPhone 16` device with `OS=26.0`
  - Xcode build command: `-destination 'platform=iOS Simulator,name=iPhone 16,OS=26.0'`
  - This project targets iOS 26 APIs and requires iOS 26 simulator for proper testing
- Verify no build errors or warnings
- Fix any issues discovered during testing in the same work cycle
- Test affected features and user flows
- Check console for runtime errors or warnings

**Testing Checklist**
- [ ] App builds successfully without errors on iOS 26 simulator
- [ ] No new warnings introduced
- [ ] Xcode Preview renders correctly
- [ ] Feature works in iPhone 16 Simulator (iOS 26)
- [ ] No console errors or warnings during testing
- [ ] Related features still work (no regressions)

### Design Implementation

**CRITICAL: Never implement based on written descriptions when Figma designs are provided**

1. **Always wait for visual access to Figma designs** before implementing UI changes
2. **Do not get creative with designs** - stick strictly to the design specs
3. If Figma access is not working, request screenshots or alternative ways to view the exact design
4. Verify design details before coding to avoid rework
5. Reference Figma components in file headers for traceability

### Figma MCP Server Troubleshooting

**Important: The Figma MCP server (running on port 3845) can only maintain one active connection at a time.**

When Figma MCP requests fail or return errors:
1. **Check if Cursor is running** - The Figma MCP server cannot simultaneously support both Cursor and VSCode/Claude Code
2. Ask the user: "Is Cursor currently running? The Figma MCP server can only connect to one client at a time."
3. If Cursor is running, request the user to close it before attempting Figma MCP operations
4. Once Cursor is closed, retry the Figma MCP request

This is a known limitation of the current Figma MCP server implementation.

### General Principles

- Prioritize accuracy over speed when implementing designs
- Ask clarifying questions if design details are unclear
- Reference specific design elements when discussing implementation
- Use component-driven development with Figma links in headers

---

## Vision & Scope

### Product Vision
Proto is a demonstration app for design prototyping iOS26 as an aid for our mobile engineering teams.

The demonstration content imagines a professional community, "Clarity", with content illustrating how the platform helps executive coaching and leadership development especially through AI transformation of the discipline. The fictional premise is Clarity enables coaches, executives, and professionals to connect, share knowledge, engage in meaningful conversations, and access curated learning content.

### Core Value Propositions
1. **Community-Driven Learning**: Feed-based content sharing with video, courses, and events
2. **Professional Networking**: Messaging system, eg for coach-executive communication in this demo community
3. **Engagement & Recognition**: Notification system with leaderboards and member discovery
4. **Admin Control**: Community management tools for moderators and admins
5. **Rich Media Support**: Video content, image attachments, and formatted messaging

### Target Audience
- Executive coaches and leadership consultants
- C-suite executives and senior managers
- Professional development enthusiasts
- Community administrators and moderators

### Current Phase
**Prototyping & Feature Development** - Building core features with mock data, preparing for backend integration

---

## Architecture Map

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        ProtoApp.swift                       │
│                     (App Entry Point)                       │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      ContentView.swift                       │
│                   (TabView Container)                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────┴─────────────────────┐
        ↓                     ↓                      ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ CommunityTab │    │ MessagesTab  │    │ SearchTab    │
└──────────────┘    └──────────────┘    └──────────────┘
        ↓                     ↓
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ PostDetails  │    │  ChatView    │    │ Searchable   │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Data Flow Pattern

```
Service Singletons
├── UnsplashService.shared
│   └── @Published images: [UnsplashImage]
└── ChatDataService.shared
    └── Conversation orchestration

        ↓ ObservedObject

Views (@State + @Binding)
├── Local UI state management
├── Parent-to-child via @Binding
└── Child-to-parent via closures

        ↓ User Actions

Services / State Updates
└── View re-renders automatically
```

### Directory Structure

```
Proto/
├── ProtoApp.swift                    # App entry point
├── ContentView.swift                 # Main tab container
├── Views/
│   ├── Tabs/                         # 4 main navigation tabs
│   │   ├── CommunityTab.swift
│   │   ├── MessagesTab.swift
│   │   ├── NotificationsTab.swift
│   │   └── SearchTab.swift
│   ├── ProfileView.swift             # Member profile view
│   ├── ChatView.swift                # Full conversation view
│   ├── PostDetails.swift             # Post detail screen
│   ├── LightboxView.swift            # Image expansion view
│   └── Components/
│       ├── Content/                  # Reusable content components
│       │   ├── PostPreview.swift     # Feed item cards
│       │   ├── Message.swift         # Chat message rows
│       │   ├── Avatar.swift          # User avatars
│       │   ├── EngagementBar.swift   # Like/comment actions
│       │   ├── Notification.swift    # Notification cards
│       │   ├── VideoPlayer.swift     # Video playback
│       │   ├── ProtoButton.swift     # Primary/secondary buttons
│       │   └── Pill.swift            # Badge/tag pills
│       ├── Menus/                    # Menu components
│       │   ├── PrimaryMenu.swift     # Main profile menu
│       │   ├── ProfileMenu.swift     # Profile action menu
│       │   ├── MessagesProfileMenu.swift
│       │   └── CreateMenu.swift      # Content creation menu
│       ├── Sheets/                   # Modal sheet interfaces
│       │   ├── SheetTemplate.swift   # Base template for all sheets
│       │   ├── AdminSettingsSheet.swift
│       │   ├── DraftsSheet.swift
│       │   ├── EditProfileSheet.swift
│       │   ├── InviteMembersSheet.swift
│       │   ├── ManageNotificationsSheet.swift
│       │   ├── PostSettingsSheet.swift
│       │   ├── SummarizeSheet.swift
│       │   └── SwitchCommunitySheet.swift
│       ├── MessageComposer.swift     # Text input with formatting
│       ├── SegmentControl.swift      # Horizontal segment control
│       └── ShimmerEffect.swift       # Loading animation
├── MockData/                         # Centralized mock data
│   ├── README.md                     # Mock data organization guide
│   ├── Messages/                     # Chat & messaging data
│   │   ├── MessagesTabData.swift
│   │   ├── DrSarahMartinezConversation.swift
│   │   ├── MichaelJenniferConversation.swift
│   │   └── DefaultConversation.swift
│   ├── Community/                    # Feed posts (future)
│   ├── Notifications/                # Notifications (future)
│   ├── Users/                        # User profiles (future)
│   └── Media/                        # Media references (future)
├── Services/
│   ├── ChatDataService.swift        # Chat orchestration (uses MockData)
│   └── UnsplashService.swift        # Image fetching
├── Extensions/
│   ├── View+Extensions.swift
│   └── Color+Extensions.swift
├── Assets.xcassets                  # Colors, icons, images
├── .claude/
│   ├── claude.md                    # This file - project memory
│   ├── mock-data-strategy.md        # Mock data organization strategy
│   └── settings.local.json          # Claude Code settings
├── docs/
│   └── archive/                     # Old documentation & Figma dumps
└── README.md                        # GitHub documentation
```

### File Organization Guidelines

**Views vs Components**

- **`Views/` (top-level)**: Independent, full-screen views that can be navigated to
  - Examples: ProfileView, ChatView, PostDetails, LightboxView
  - These are destination views in navigation flows
  - Not reusable components, but complete view implementations

- **`Views/Components/`**: Reusable UI building blocks and specialized sub-views

**Component Organization**

- **`Components/Content/`**: Reusable content components
  - UI elements that render data or provide interaction
  - Examples: PostPreview, Message, Avatar, EngagementBar, ProtoButton, Pill
  - Should be generic and reusable across multiple contexts
  - Typically data-driven (take models or data as parameters)

- **`Components/Menus/`**: Menu components
  - All Menu-related components that appear in toolbars or as popups
  - Examples: PrimaryMenu, ProfileMenu, CreateMenu, MessagesProfileMenu

- **`Components/Sheets/`**: Modal sheet interfaces
  - All sheet presentations using SheetTemplate
  - Examples: EditProfileSheet, AdminSettingsSheet, DraftsSheet
  - Should use SheetTemplate for consistency

- **`Components/` (root level)**: Other specialized components
  - Components that don't fit into above categories
  - Examples: MessageComposer, SegmentControl, ShimmerEffect
  - Typically have specific, singular purposes

### Architecture Principles

**MVVM-Adjacent with SwiftUI**
- Views: Pure UI components (structs)
- View Models: Service classes (ObservableObject)
- Models: Plain structs for data
- No global state container (no Redux/Combine stores)

**State Management Strategy**
- `@State` for view-local UI state
- `@Binding` for parent-child communication
- `@Environment` for system-level properties
- `@ObservedObject` for shared services
- Singleton services for shared data (`.shared` pattern)

**Service Pattern**
- Singleton services (`UnsplashService.shared`)
- Static helper methods (`MessagesTabData`, `TextFormattingHelper`)
- Mock data in service layer (preparing for backend)
- Closure-based event communication

---

## UI Guidelines

### Design System

**Color Palette** (Semantic Colors)
```swift
// Light Mode          // Dark Mode
.primary      #191b1f | #f0f3f5
.secondary    #42464d | #c9cbce
.tertiary     #717680 | #858993
.quaternary   #90929d | #676b74
```

**Notification Colors**
- Red: Critical alerts
- Orange: Mentions
- Teal: Threads
- Yellow: Following
- Purple (#9676f8): AI/replies

**Spacing Standards**
- Base unit: 8pt
- Standard horizontal padding: 16pt
- Component spacing: 12pt, 16pt, 24pt
- Corner radius: 12pt (standard), 18pt (buttons)

**Typography**
- Primary: `.body` with `.fontWeight(.semibold)` for emphasis
- Secondary: `.caption` or `.subheadline`
- Titles: `.title3` with `.fontWeight(.semibold)`

### Component Library

| Component | Purpose | Variants | Key Props |
|-----------|---------|----------|-----------|
| **Avatar** | User representation | `.default`, `.online`, `.group`, size variants (24-160pt) | `imageName`, `initials`, `size` |
| **Message** | Chat message row | `.full`, `.preview` | `name`, `avatarImage`, `messageText`, `context` |
| **PostPreview** | Feed item card | - | `post`, `onLikeTapped`, `onCommentTapped` |
| **EngagementBar** | Like/comment actions | - | `likeCount`, `commentCount`, closures |
| **SegmentControl** | Horizontal tabs | - | `options`, `selectedIndex`, `onSelectionChanged` |
| **MessageComposer** | Text input | - | `text`, `onSend`, formatting support |
| **SheetTemplate** | Modal container | - | `title`, `subtitle`, `primaryAction`, `secondaryAction` |
| **LightboxView** | Image expansion | Single/multi-image | `image`, `images`, `startingIndex`, `isPresented` |

### Layout Patterns

**Screen Structure**
```swift
NavigationStack {
    ScrollView {
        LazyVStack {
            // Content
        }
    }
    .safeAreaInset(edge: .bottom) {
        // MessageComposer or action bar
    }
    .toolbar { }
}
```

**Modal Sheets**
```swift
.sheet(isPresented: $showSheet) {
    SheetTemplate(
        title: "Title",
        subtitle: "Description",
        primaryAction: SheetAction(label: "Action", action: {}),
        secondaryAction: SheetAction(label: "Cancel", action: {})
    ) {
        // Sheet content
    }
    .presentationDetents([.medium, .large])
}
```

**Lightbox Pattern**
```swift
.overlay {
    if showLightbox {
        LightboxView(image: image, isPresented: $showLightbox)
            .transition(.opacity)
            .zIndex(999)
    }
}
.onTapGesture {
    withAnimation { showLightbox = true }
}
```

### iOS 18+ Features Used
- **NavigationStack**: Modern navigation (replaces NavigationView)
- **TabView**: Native tab bar with `.tabBarMinimizeBehavior(.onScrollDown)`
- **Sheet detents**: `.medium`, `.large` presentations
- **Searchable**: Native search integration with `.searchToolbarBehavior(.automatic)`
- **Liquid Glass**: `.ultraThinMaterial`, `.glassEffect()` (iOS 26+)
- **MatchedGeometryEffect**: Smooth zoom transitions for lightbox

### Animation Standards
- Default: `.easeInOut` with 0.3s duration
- Lightbox: `.spring(response: 0.3, dampingFraction: 0.8)`
- Tab transitions: `.zoom` with matched geometry
- Button feedback: `.scaleEffect` on tap

---

## Code Style

### Naming Conventions

**Files**
- PascalCase matching struct/view name: `PostPreview.swift`
- Service suffix for services: `UnsplashService.swift`
- Data suffix for data providers: `MessagesTabData.swift`

**Types**
- PascalCase for structs, enums, protocols: `MessageData`, `AvatarVariant`
- Descriptive names: `UnsplashImage` not `UIImage`

**Variables & Properties**
- camelCase: `selectedTintColor`, `isOnline`, `postImageName`
- Boolean prefixes: `is`, `has`, `should`, `can`
- Constants: camelCase with context: `standardHorizontalPadding = 16`

**Functions**
- camelCase with verb prefix: `fetchImages()`, `handleLikeTap()`
- Clear action names: `onLikeTapped`, `onSelectionChanged`

### Code Organization

**Standard File Structure**
```swift
// MARK: - Imports
import SwiftUI
import AVKit

// MARK: - Main Component
struct ComponentName: View {
    // MARK: - Properties
    // State properties
    @State private var localState = false

    // Bindings
    @Binding var sharedState: Bool

    // Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - Body
    var body: some View {
        // View code
    }
}

// MARK: - Helper Views
private extension ComponentName {
    var helperView: some View {
        // Extracted view
    }
}

// MARK: - Helper Functions
private extension ComponentName {
    func helperFunction() {
        // Logic
    }
}

// MARK: - Preview
#Preview {
    ComponentName()
}
```

**MARK Comment Standards**
- `// MARK: - Section Name` for major sections
- `// MARK: Helper Functions` for subsections
- Use sparingly, only for logical groupings

### SwiftUI Best Practices

**View Composition**
```swift
// ✅ Preferred: Extract complex views
var messageRow: some View {
    HStack { /* ... */ }
}

// ❌ Avoid: Inline complex views
var body: some View {
    VStack {
        HStack { /* 50 lines */ }
    }
}
```

**State Management**
```swift
// ✅ Preferred: Local state with bindings
@State private var text = ""

// ✅ Pass down as binding
TextField("", text: $text)

// ❌ Avoid: Unnecessary @StateObject for simple data
```

**Modifiers Order**
1. Layout (frame, padding)
2. Appearance (foregroundColor, background)
3. Interaction (onTapGesture)
4. Accessibility
5. Navigation/Sheets

**Performance Patterns**
```swift
// ✅ Use LazyVStack for long lists
LazyVStack { ForEach(items) { } }

// ✅ Extract expensive computed properties
private var formattedDate: String { /* ... */ }

// ✅ Cache images/avatars
@State private var cachedAvatars: [String: Image] = [:]
```

**Navigation Patterns**
```swift
// ✅ Pushed views get automatic back button - don't add manually
struct ProfileView: View {
    var body: some View {
        ScrollView {
            // Content
        }
        // No .navigationBarTitle() needed if not using title
        // No manual back button needed - SwiftUI adds automatically
    }
}

// ✅ Only add toolbar items for additional actions
.toolbar {
    ToolbarItem(placement: .topBarTrailing) {
        Menu { /* ... */ } label: { Image(systemName: "ellipsis") }
    }
}

// ❌ Avoid: Manual back buttons in pushed views
@Environment(\.dismiss) private var dismiss  // Not needed unless custom back logic
Button("Back") { dismiss() }  // Don't add - automatic back button is better

// ❌ Avoid: Unnecessary navigation titles
.navigationBarTitle("")  // Don't add if view doesn't need a title
.toolbarTitleDisplayMode(.inline)  // Don't add if not using title
```

**IMPORTANT**: When creating new destination views (views that are navigated to via NavigationStack):
- Do NOT add manual back buttons - SwiftUI provides these automatically
- Do NOT add `@Environment(\.dismiss)` unless you need custom dismissal logic
- Do NOT add `.navigationBarTitle()` or `.toolbarTitleDisplayMode()` unless the view needs a title
- Only add `.toolbar` items if you need additional actions (like menus, share buttons, etc.)

### Documentation

**File Headers**
```swift
// ComponentName.swift
// Brief description of component purpose
// Figma: [link if component-driven]
```

**Inline Comments**
- Explain "why", not "what"
- Use for non-obvious logic only
- TODO format: `// TODO: Feature description`

**Documentation Comments** (for public APIs)
```swift
/// Brief description
/// - Parameters:
///   - param: Description
/// - Returns: Description
func publicFunction(param: String) -> Bool
```

### Error Handling

**Optional Unwrapping**
```swift
// ✅ Preferred: Guard for early returns
guard let image = cachedImage else { return placeholderView }

// ✅ Use if-let for conditional rendering
if let url = URL(string: urlString) { /* ... */ }
```

**Debugging**
```swift
// ✅ Use print for development
print("DEBUG: User tapped like on post \(postId)")

// ✅ Fallback UI for errors
RoundedRectangle(cornerRadius: 12)
    .fill(.quaternary)
```

---

## Decision Log

### Architectural Decisions

**[2024-Q4] No Global State Management**
- **Decision**: Use local `@State` with service singletons instead of Redux/Combine stores
- **Rationale**: Prototyping phase prioritizes feature velocity; SwiftUI's local state is sufficient for current scope
- **Trade-offs**: May need refactor if cross-view state complexity increases
- **Status**: Active

**[2024-Q4] Singleton Services Pattern**
- **Decision**: Use `.shared` singletons for `UnsplashService` and `ChatDataService`
- **Rationale**: Simple data sharing without complex DI frameworks
- **Trade-offs**: Testing requires mocking singletons or dependency injection refactor
- **Status**: Active

**[2024-Q4] Mock Data in Services**
- **Decision**: Store mock conversation data in service layer (`MessagesTabData`, conversation files)
- **Rationale**: Mimics real data flow, easy to swap for network calls later
- **Trade-offs**: More files to maintain, but better separation than inline data
- **Status**: Temporary (pending backend integration)

**[2024-Q4] AttributedString for Rich Text**
- **Decision**: Use SwiftUI's `AttributedString` instead of `NSAttributedString`
- **Rationale**: Native SwiftUI API, better playground support, cleaner interop
- **Trade-offs**: iOS 15+ only, but app targets iOS 18+
- **Status**: Active

**[2024-Q4] Closure-Based Communication**
- **Decision**: Prefer closures over complex bindings for event callbacks
- **Rationale**: Clearer intent, easier debugging, less state management
- **Example**: `onLikeTapped: { print("Like tapped!") }`
- **Status**: Active

### UI/UX Decisions

**[2024-Q4] Collapsible Tab Bar**
- **Decision**: Use `.tabBarMinimizeBehavior(.onScrollDown)` for immersive scrolling
- **Rationale**: Maximizes content space, modern iOS pattern
- **Status**: Active

**[2024-Q4] Liquid Glass Material Effects**
- **Decision**: Use `.ultraThinMaterial` and `.glassEffect()` for overlays
- **Rationale**: Modern iOS 18+ aesthetic, aligns with Apple HIG
- **Trade-offs**: iOS 26+ only for full effect
- **Status**: Active

**[2024-Q4] Bottom-Anchored Message Composer**
- **Decision**: Use `.safeAreaInset(edge: .bottom)` for persistent composer
- **Rationale**: Native iOS messaging pattern, avoids keyboard overlap issues
- **Status**: Active

**[2024-Q4] Zoom Transitions for Lightbox**
- **Decision**: Use `MatchedGeometryEffect` for image expansion
- **Rationale**: Smooth, contextual transition; Apple Photos-style UX
- **Status**: Active

### Technical Decisions

**[2024-Q4] Unsplash API for Dynamic Images**
- **Decision**: Integrate Unsplash API for realistic prototype images
- **Rationale**: Professional quality images without asset bloat
- **Trade-offs**: Requires network, API rate limits
- **Status**: Active (prototyping), may replace with CDN

**[2024-Q4] AVKit for Video Playback**
- **Decision**: Use native `AVPlayer` with custom controls
- **Rationale**: Best performance, native iOS features
- **Alternative Considered**: Third-party video players
- **Status**: Active

**[2024-Q4] Figma Component-Driven Development**
- **Decision**: Reference Figma components in file headers
- **Rationale**: Maintains design-code alignment, eases handoff
- **Process**: Designer shares Figma links → developer implements → references link
- **Status**: Active

**[2025-10-16] Documentation Organization**
- **Decision**: Move project memory to `.claude/claude.md`, archive old docs to `docs/archive/`
- **Rationale**: Keep root directory clean, only README.md visible on GitHub
- **Status**: Active

**[2025-10-16] Unified Mock Data Organization**
- **Decision**: Create centralized `Proto/MockData/` directory organized by domain (Messages, Community, Notifications, Users, Media)
- **Rationale**:
  - Eliminates inconsistency between unused Figma JSON dumps and Swift mock data
  - Provides clear organizational pattern for future development
  - Separates data definitions from service logic
  - Prepares for easy backend integration via protocol-based data sources
- **Migration**: Moved `Services/Conversations/` → `MockData/Messages/`, archived 6 unused Figma JSON files (~400KB)
- **Trade-offs**: One-time migration effort, but establishes scalable pattern
- **Status**: Active

---

## Triage & Workflow

### Branch Strategy

**Branch Naming**
```
feature/short-description       # New features
fix/bug-description            # Bug fixes
refactor/component-name        # Code refactoring
docs/topic                     # Documentation
chore/task-description         # Maintenance tasks
```

**Examples**
- `feature/message-composer-formatting-toggle` ✅
- `fix/avatar-loading-crash` ✅
- `refactor/chat-state-management` ✅

**Branch Lifecycle**
1. **Create**: Branch from `main` for new work
2. **Develop**: Commit frequently with clear messages
3. **PR**: Open pull request with comprehensive description
4. **Review**: Request review, address feedback
5. **Merge**: Squash and merge to `main`
6. **Delete**: Remove branch after merge

**Main Branch**
- `main`: Production-ready code
- Protected: Requires PR for changes
- Always buildable and runnable

### Commit Message Format

**Structure**
```
<type>: <subject>

[optional body]

[optional footer with PR reference]
```

**Types**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code restructuring
- `style`: Formatting, whitespace
- `docs`: Documentation only
- `test`: Adding tests
- `chore`: Maintenance, tooling

**Examples**
```
feat: add bold/italic/underline text formatting to MessageComposer

Implemented AttributedString-based formatting with:
- Format menu with toggles
- Selection range tracking
- Active state indicators
- Append mode for empty text

Fixes #42
```

```
fix: resolve avatar loading crash in group chats

Guard against nil avatar images with placeholder fallback.
```

### Pull Request Guidelines

**PR Title**
- Match commit message format
- Clear, action-oriented
- Example: `feat: chat improvements demo 💬`

**PR Description Template**
```markdown
## Summary
- Bullet points of key changes

## What Users Can Do
- User-facing feature descriptions

## Technical Highlights
- Implementation details
- Architectural changes

## Test Plan
- Manual testing checklist
- Edge cases covered

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Review Checklist**
- [ ] Code follows style guide
- [ ] No console warnings or errors
- [ ] Preview builds and displays correctly
- [ ] Changes are scoped to PR description
- [ ] Figma references updated (if applicable)
- [ ] TODOs are tracked or resolved

### Issue Triage

**Priority Levels**
- **P0 (Critical)**: App crashes, data loss, security issues
- **P1 (High)**: Major feature broken, poor UX
- **P2 (Medium)**: Minor bugs, enhancement requests
- **P3 (Low)**: Nice-to-haves, technical debt

**Labels**
- `bug`: Something isn't working
- `enhancement`: New feature or improvement
- `refactor`: Code quality improvement
- `design`: UI/UX changes needed
- `backend`: Requires backend work
- `blocked`: Waiting on dependency

**Workflow States**
```
Backlog → Triage → In Progress → Review → Done
```

### Rituals

**Daily Development**
1. Pull latest `main`
2. Create feature branch
3. Implement with frequent commits
4. **Test in iPhone 16 Simulator** before marking tasks complete
   - Build and run the app (Cmd + R)
   - Verify no build errors or warnings
   - Test affected features and user flows
   - Check console for runtime errors
   - Fix any issues before proceeding
5. Open PR when complete and tested

**Code Review Expectations**
- Respond to reviews within 24 hours
- Address all feedback or explain reasoning
- Re-request review after changes
- Thank reviewers

**Release Checklist**
- [ ] All PRs merged to `main`
- [ ] App builds without warnings
- [ ] Manual smoke test on device
- [ ] Update README if needed
- [ ] Tag release: `git tag v1.x.x`

---

## Active Context

### Current Features in Development
- [x] Message composer formatting (bold, italic, underline, strikethrough)
- [x] Multi-image lightbox with swipe navigation
- [x] Chat view improvements
- [x] Video autoplay on scroll

### Known TODOs
- iPad multi-column layouts
- Enhanced video controls (tap to unmute, fullscreen, PiP)
- Admin co-pilot sparkle UI
- Member profile screens
- Video upload capability
- Connection actions via profile
- Replace SF Symbols with custom icons
- Backend integration for real data

### Tech Debt
- Singleton services need dependency injection for testing
- Mock data should move to separate mock layer
- Some views exceed 200 lines (consider extraction)
- Print statements should become structured logging
- AttributedString helper methods could be centralized

---

## Quick Reference

### Key Files to Know
- [ProtoApp.swift](../ProtoApp.swift): App entry, initialization
- [ContentView.swift](../ContentView.swift): Tab container, global state
- [ChatView.swift](../Proto/Views/Components/ChatView.swift): Complex state example, message rendering
- [MessageComposer.swift](../Proto/Views/Components/MessageComposer.swift): Rich text formatting, AttributedString
- [UnsplashService.swift](../Proto/Services/UnsplashService.swift): Network service pattern
- [Color+Extensions.swift](../Proto/Extensions/Color+Extensions.swift): Semantic color system
- [View+Extensions.swift](../Proto/Extensions/View+Extensions.swift): Reusable view modifiers
- [SheetTemplate.swift](../Proto/Views/Components/Sheets/SheetTemplate.swift): Modal sheet pattern

### Common Commands
```bash
# Run in Xcode
Cmd + R

# Preview in Canvas
Cmd + Option + P

# Format code
Ctrl + I

# Find in project
Cmd + Shift + F

# Git status
git status

# Create feature branch
git checkout -b feature/description

# Commit changes
git add .
git commit -m "feat: description"

# Push and create PR
git push -u origin feature/description
gh pr create
```

### Helpful Links
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [AttributedString Guide](https://developer.apple.com/documentation/foundation/attributedstring)
- [iOS 18 What's New](https://developer.apple.com/documentation/updates/swiftui)

---

## Change History

| Date | Change | Author |
|------|--------|--------|
| 2025-10-16 | Initial project memory document creation | Claude + User |
| 2025-10-16 | Merged with rules.md, reorganized docs structure | Claude + User |

---

*This document is a living reference. Update it whenever architectural decisions are made, patterns evolve, or new conventions are established.*