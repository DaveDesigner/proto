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
    
    init(initials: String? = nil, imageName: String? = nil, size: CGFloat = 24) {
        self.initials = initials
        self.imageName = imageName
        self.size = size
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
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Test single names
        HStack(spacing: 12) {
            Avatar(initials: "Alex", size: 24)
            Avatar(initials: "Maria", size: 24)
            Avatar(initials: "David", size: 24)
        }
        
        // Test two names (first + last)
        HStack(spacing: 12) {
            Avatar(initials: "Sally Flower", size: 32)
            Avatar(initials: "David Chen", size: 32)
            Avatar(initials: "Alex Johnson", size: 32)
        }
        
        // Test multiple names (first + middle + last)
        HStack(spacing: 12) {
            Avatar(initials: "Christopher Alexander Johnson", size: 40)
            Avatar(initials: "Dr. Elizabeth Margaret Thompson-Williams", size: 40)
            Avatar(initials: "Maria Elena Rodriguez", size: 40)
        }
        
        // Test already processed initials
        HStack(spacing: 12) {
            Avatar(initials: "SF", size: 24)
            Avatar(initials: "DC", size: 24)
            Avatar(initials: "AJ", size: 24)
        }
        
        // Test image avatars
        HStack(spacing: 12) {
            Avatar(imageName: "Avatar", size: 24)
            Avatar(imageName: "Avatar", size: 32)
            Avatar(imageName: "Avatar", size: 40)
        }
    }
    .padding()
}
