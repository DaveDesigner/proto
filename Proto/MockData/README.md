# MockData

This directory contains all mock/demo data for the Proto app, organized by feature domain.

## Purpose

During prototyping and development, mock data allows us to:
- Build and test UI without backend dependencies
- Demonstrate features with realistic content
- Maintain type-safe, compile-time-checked data
- Easily transition to real API integration later

## Directory Structure

```
MockData/
├── Messages/              # Chat and messaging data
│   ├── MessagesTabData.swift
│   ├── DrSarahMartinezConversation.swift
│   ├── MichaelJenniferConversation.swift
│   └── DefaultConversation.swift
├── Community/             # Feed posts, courses, events (future)
├── Notifications/         # Notification samples (future)
├── Users/                 # User profiles and avatars (future)
└── Media/                 # Media references (future)
```

## Principles

### 1. Swift-Native Data Only
All mock data is defined as Swift structs/arrays, **not JSON files**:
- ✅ Type-safe at compile time
- ✅ Auto-complete in Xcode
- ✅ Easy to refactor
- ✅ Clear relationships between models
- ❌ No JSON parsing overhead
- ❌ No runtime errors from malformed JSON

### 2. Domain-Based Organization
Mock data is grouped by feature domain, not by data type:
- `Messages/` - All messaging and chat-related data
- `Community/` - Feed posts, courses, events
- `Notifications/` - Notification samples
- `Users/` - User profiles, avatars

This mirrors how real features are organized and makes it easy to find relevant data.

### 3. Separation from Services
- **MockData/** contains ONLY static data definitions
- **Services/** contains business logic that USES mock data
- Services can easily swap between mock and real data sources

### 4. Clear Naming Conventions
- `*Data.swift` suffix for data providers (e.g., `MessagesTabData.swift`)
- `*Conversation.swift` suffix for conversation scenarios
- Static methods: `static func getAll()`, `static func create()`, `static func sample()`

## Usage Examples

### Accessing Mock Data

```swift
// In a service
class ChatDataService: ObservableObject {
    func getAllMessagePreviews() -> [MessageData] {
        return MessagesTabData.getAllMessagePreviews()
    }

    func getConversation(for messageData: MessageData) -> (ChatContext, [ChatMessage]) {
        return MessagesTabData.createConversation(for: messageData)
    }
}
```

### Adding New Mock Data

When adding new features, create corresponding mock data files:

```swift
//
//  PostsData.swift
//  Proto/MockData/Community
//

import Foundation

struct PostsData {
    /// All sample posts for the community feed
    static func getAllPosts() -> [Post] {
        return [
            Post(
                id: "1",
                authorName: "Dr. Sarah Martinez",
                content: "Just finished an incredible AI coaching session...",
                timestamp: Date().addingTimeInterval(-3600),
                likeCount: 24,
                commentCount: 8
            ),
            // ... more posts
        ]
    }

    /// Single sample post for previews/testing
    static func samplePost() -> Post {
        return getAllPosts().first!
    }
}
```

## Future: Backend Integration

When integrating with a real backend, use protocol-based data sources:

```swift
protocol PostsDataSource {
    func getAllPosts() async throws -> [Post]
}

// Mock implementation (current)
class MockPostsDataSource: PostsDataSource {
    func getAllPosts() async throws -> [Post] {
        return PostsData.getAllPosts()
    }
}

// Real implementation (future)
class APIPostsDataSource: PostsDataSource {
    func getAllPosts() async throws -> [Post] {
        let url = URL(string: "\(apiBaseURL)/posts")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
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

## Guidelines

### Do
- ✅ Define mock data as Swift structs/arrays
- ✅ Use static methods for data access
- ✅ Provide realistic, contextual data
- ✅ Keep data organized by feature domain
- ✅ Include variety (different dates, states, edge cases)

### Don't
- ❌ Define mock data directly in Services
- ❌ Use JSON files for mock data
- ❌ Mix mock data with UI components
- ❌ Hardcode data in views
- ❌ Use overly simplistic/unrealistic data

## Current Mock Data

### Messages (Implemented)
- **MessagesTabData.swift**: 14 message preview samples spanning 3 months
- **DrSarahMartinezConversation.swift**: Full conversation with coaching context
- **MichaelJenniferConversation.swift**: Group chat conversation
- **DefaultConversation.swift**: Generic conversation template

### Community (Future)
- PostsData.swift - Feed posts with images, likes, comments
- CoursesData.swift - Learning courses and modules
- EventsData.swift - Community events and workshops

### Notifications (Future)
- NotificationsData.swift - Various notification types (likes, mentions, AI, events)

### Users (Future)
- UsersData.swift - User profiles, avatars, bios

---

*For the complete mock data strategy and rationale, see [../../.claude/mock-data-strategy.md](../../.claude/mock-data-strategy.md)*