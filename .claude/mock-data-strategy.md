# Mock Data Strategy

## Problem Statement

Currently, Proto has inconsistent approaches to mock/demo data:
1. **Figma JSON dumps** in root (unused): `avatar-node.json`, `engagement-bar-node.json`, etc.
2. **Swift static data** in `Services/Conversations/`: Clean, typed data
3. **Mixed location patterns**: Some data in Services, no clear organizational principle

## Proposed Solution: Unified Mock Data Architecture

### Directory Structure

```
Proto/
├── MockData/                           # NEW: Centralized mock data
│   ├── README.md                       # Documentation of mock data patterns
│   ├── Messages/                       # Chat & messaging data
│   │   ├── MessagesTabData.swift
│   │   ├── DrSarahMartinezConversation.swift
│   │   ├── MichaelJenniferConversation.swift
│   │   └── DefaultConversation.swift
│   ├── Community/                      # Feed & community data
│   │   ├── PostsData.swift
│   │   ├── CoursesData.swift
│   │   └── EventsData.swift
│   ├── Notifications/                  # Notification data
│   │   └── NotificationsData.swift
│   ├── Users/                          # User profiles & avatars
│   │   └── UsersData.swift
│   └── Media/                          # Image/video references
│       └── MediaData.swift
├── Services/
│   ├── ChatDataService.swift          # Service layer (references MockData)
│   ├── UnsplashService.swift          # External API integration
│   └── ...
```

### Principles

1. **Swift-Native Mock Data**: All mock data as typed Swift structs/arrays (no JSON)
   - Type-safe at compile time
   - Auto-complete in Xcode
   - Easy to refactor
   - Clear relationships

2. **Domain-Based Organization**: Group by feature domain, not data type
   - `MockData/Messages/` for all messaging-related data
   - `MockData/Community/` for feed/posts/courses
   - `MockData/Notifications/` for notification types

3. **Separation of Concerns**:
   - `MockData/` contains ONLY static data definitions
   - `Services/` contains business logic that USES mock data
   - Services can easily swap between mock and real data sources

4. **Clear Naming Convention**:
   - `*Data.swift` suffix for data providers (e.g., `MessagesTabData.swift`)
   - `*Conversation.swift` suffix for conversation scenarios
   - Static methods: `static func getAll()`, `static func create()`, `static func sample()`

### Migration Plan

#### Phase 1: Archive Unused Figma JSON
```bash
# Move to docs/archive/figma-dumps/
mv avatar-node.json docs/archive/figma-dumps/
mv engagement-bar-node.json docs/archive/figma-dumps/
mv postpreview-node.json docs/archive/figma-dumps/
mv list-item-node.json docs/archive/figma-dumps/
mv post-metadata-states.json docs/archive/figma-dumps/
mv divider-node.json docs/archive/figma-dumps/
```

#### Phase 2: Create MockData Directory
```bash
mkdir -p Proto/MockData/{Messages,Community,Notifications,Users,Media}
```

#### Phase 3: Move Existing Mock Data
```bash
# Move conversation data
mv Proto/Services/Conversations/* Proto/MockData/Messages/
rmdir Proto/Services/Conversations
```

#### Phase 4: Update Service References
- Update `ChatDataService.swift` to import from `MockData/Messages/`
- Update any other services referencing conversation data

#### Phase 5: Create New Mock Data Files (Future)
- `Proto/MockData/Community/PostsData.swift` - Feed posts
- `Proto/MockData/Notifications/NotificationsData.swift` - Notification samples
- `Proto/MockData/Users/UsersData.swift` - User profiles/avatars

### Example: Mock Data File Template

```swift
//
//  PostsData.swift
//  Proto
//
//  Mock data for community feed posts
//

import Foundation

struct PostsData {
    /// All sample posts for the community feed
    static func getAllPosts() -> [PostPreview] {
        return [
            PostPreview(
                id: "1",
                authorName: "Dr. Sarah Martinez",
                authorAvatar: "avatar1",
                timestamp: "2 hours ago",
                content: "Just finished an incredible AI coaching session...",
                imageUrl: nil,
                likeCount: 24,
                commentCount: 8,
                hasLiked: false
            ),
            // ... more posts
        ]
    }

    /// Sample post for previews/testing
    static func samplePost() -> PostPreview {
        return getAllPosts().first!
    }

    /// Posts filtered by category
    static func getPosts(category: PostCategory) -> [PostPreview] {
        return getAllPosts().filter { $0.category == category }
    }
}
```

### Future: Backend Integration Strategy

When integrating with a real backend:

```swift
protocol PostsDataSource {
    func getAllPosts() async throws -> [PostPreview]
}

// Mock implementation (current)
class MockPostsDataSource: PostsDataSource {
    func getAllPosts() async throws -> [PostPreview] {
        return PostsData.getAllPosts()
    }
}

// Real implementation (future)
class APIPostsDataSource: PostsDataSource {
    func getAllPosts() async throws -> [PostPreview] {
        // Network call to backend
        let url = URL(string: "\(apiBaseURL)/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([PostPreview].self, from: data)
    }
}

// Service uses protocol, easily swappable
class CommunityService: ObservableObject {
    private let dataSource: PostsDataSource

    init(dataSource: PostsDataSource = MockPostsDataSource()) {
        self.dataSource = dataSource
    }
}
```

### Benefits

1. **Clear Organization**: Developer immediately knows where to find/add mock data
2. **Easy Testing**: Services can inject mock vs. real data sources
3. **No JSON Parsing**: Swift types mean faster iteration and compile-time safety
4. **Clean Root Directory**: No data files cluttering the project root
5. **Scalable**: Easy to add new domains (e.g., `MockData/Analytics/`)
6. **Backend-Ready**: Protocol-based design makes swapping to API trivial

### Decision Record

- **Date**: 2025-10-16
- **Decision**: Adopt unified MockData directory structure with Swift-native mock data
- **Rationale**:
  - Current approach has Figma JSON dumps unused in root
  - Swift static data is cleaner and more maintainable than JSON
  - Separation of mock data from service logic enables easier testing
  - Mimics real backend integration patterns
- **Trade-offs**:
  - Migration effort to move existing files
  - Need to update import statements
- **Status**: Proposed (awaiting approval)