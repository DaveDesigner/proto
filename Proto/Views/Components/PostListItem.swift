//
//  PostListItem.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct PostListItem: View {
    let title: String
    let authorName: String
    let timeAgo: String
    let initials: String?
    
    init(
        title: String,
        authorName: String,
        timeAgo: String,
        initials: String? = nil
    ) {
        self.title = title
        self.authorName = authorName
        self.timeAgo = timeAgo
        self.initials = initials
    }
    
    var body: some View {
        Button(action: {
            // TODO: Handle tap action
        }) {
            HStack(alignment: .top, spacing: 16) {
                // Leading avatar
                if let initials = initials {
                    InitialsAvatar(initials: initials)
                } else {
                    Image("Avatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(authorName) • Draft updated \(timeAgo)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InitialsAvatar: View {
    let initials: String
    
    private let colors = [
        Color(hex: "3A691C"),
        Color(hex: "1D5F69"),
        Color(hex: "246693"),
        Color(hex: "BE2C80"),
        Color(hex: "B331BE"),
        Color(hex: "7230BC")
    ]
    
    private var avatarColor: Color {
        let hash = initials.hashValue
        let index = abs(hash) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatarColor)
                .frame(width: 44, height: 44)
            
            Text(initials)
                .font(.body.weight(.medium))
                .foregroundStyle(.white)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        PostListItem(
            title: "Discovering My Vietnamese Heritage: A Journey to Vietnam and Passing Down the Family Pho Recipe to all",
            authorName: "Dave Morgan",
            timeAgo: "1h ago",
            initials: "DM"
        )
        
        PostListItem(
            title: "Draft post",
            authorName: "Dave Morgan",
            timeAgo: "2h ago",
            initials: "DM"
        )
    }
}
