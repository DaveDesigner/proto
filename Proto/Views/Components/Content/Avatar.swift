//
//  Avatar.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/PzUzcvddOq22gYb5aPCAnM/Teaching-Cursor-mobile-components-1-at-a-time?node-id=1-232&p=f&t=yPG9JEmux6qoTlmT-11
//

import SwiftUI

struct Avatar: View {
    let initials: String?
    let imageName: String?
    let size: CGFloat
    let isOnline: Bool
    
    init(initials: String? = nil, imageName: String? = nil, size: CGFloat = 24, isOnline: Bool = false) {
        self.initials = initials
        self.imageName = imageName
        self.size = size
        self.isOnline = isOnline
    }
    
    // Computed property to extract first two initials from a full name
    private var processedInitials: String? {
        guard let initials = initials else { return nil }
        
        // If it's already 2 characters or less, return as is
        if initials.count <= 2 {
            return initials.uppercased()
        }
        
        // Split by spaces and filter out empty strings
        let nameParts = initials.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        // If we have at least 2 parts, take first letter of first and last
        if nameParts.count >= 2 {
            let firstInitial = String(nameParts.first?.prefix(1) ?? "")
            let lastInitial = String(nameParts.last?.prefix(1) ?? "")
            return (firstInitial + lastInitial).uppercased()
        }
        
        // If we only have one part, take first two characters
        if nameParts.count == 1 {
            let name = nameParts[0]
            if name.count >= 2 {
                return String(name.prefix(2)).uppercased()
            } else {
                return name.uppercased()
            }
        }
        
        // Fallback: take first two characters of the original string
        return String(initials.prefix(2)).uppercased()
    }
    
    private let colors = [
        Color(red: 0.447, green: 0.188, blue: 0.737), // Purple
        Color(red: 0.702, green: 0.192, blue: 0.745), // Pink
        Color(red: 0.745, green: 0.173, blue: 0.502), // Magenta
        Color(red: 0.141, green: 0.400, blue: 0.576), // Blue
        Color(red: 0.114, green: 0.373, blue: 0.412), // Teal
        Color(red: 0.227, green: 0.412, blue: 0.109)  // Green
    ]
    
    private var avatarColor: Color {
        guard let processedInitials = processedInitials else { return .secondary.opacity(0.3) }
        let hash = processedInitials.hashValue
        return colors[abs(hash) % colors.count]
    }
    
    private var fontSize: CGFloat {
        size * 0.46 // 11pt for 24pt size as per Figma
    }
    
    var body: some View {
        ZStack {
            if let imageName = imageName {
                // Image avatar
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else if let processedInitials = processedInitials {
                // Initials avatar
                Circle()
                    .fill(avatarColor)
                    .frame(width: size, height: size)
                    .overlay(
                        Text(processedInitials)
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.white)
                    )
            } else {
                // Fallback avatar
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .frame(width: size, height: size)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    )
            }
            
            // Online status indicator
            if isOnline {
                Circle()
                    .fill(Color.green)
                    .frame(width: onlineIndicatorSize, height: onlineIndicatorSize)
                    .offset(x: onlineIndicatorOffset, y: onlineIndicatorOffset)
            }
        }
    }
    
    // MARK: - Online Status Properties
    private var onlineIndicatorSize: CGFloat {
        size * 0.2 // 20% of avatar size
    }
    
    private var onlineIndicatorOffset: CGFloat {
        size * 0.35 // Position indicator at bottom-right
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Test single names with online status
        HStack(spacing: 12) {
            Avatar(initials: "Alex", size: 24, isOnline: true)
            Avatar(initials: "Maria", size: 24, isOnline: false)
            Avatar(initials: "David", size: 24, isOnline: true)
        }
        
        // Test two names (first + last) with online status
        HStack(spacing: 12) {
            Avatar(initials: "Sally Flower", size: 32, isOnline: true)
            Avatar(initials: "David Chen", size: 32, isOnline: false)
            Avatar(initials: "Alex Johnson", size: 32, isOnline: true)
        }
        
        // Test multiple names (first + middle + last) with online status
        HStack(spacing: 12) {
            Avatar(initials: "Christopher Alexander Johnson", size: 40, isOnline: true)
            Avatar(initials: "Dr. Elizabeth Margaret Thompson-Williams", size: 40, isOnline: false)
            Avatar(initials: "Maria Elena Rodriguez", size: 40, isOnline: true)
        }
        
        // Test already processed initials with online status
        HStack(spacing: 12) {
            Avatar(initials: "SF", size: 24, isOnline: true)
            Avatar(initials: "DC", size: 24, isOnline: false)
            Avatar(initials: "AJ", size: 24, isOnline: true)
        }
        
        // Test image avatars with online status
        HStack(spacing: 12) {
            Avatar(imageName: "Avatar", size: 24, isOnline: true)
            Avatar(imageName: "Avatar", size: 32, isOnline: false)
            Avatar(imageName: "Avatar", size: 40, isOnline: true)
        }
    }
    .padding()
}
