//
//  Avatar.swift
//  Proto
//
//  Generated from Figma component
//  https://www.figma.com/design/W7x7IvJBDsSw43zcIKMJeR/%E2%9D%96-Mobile-Design-System?node-id=13138-130387&t=3gJqoSz2w5aNwUCA-11
//

import SwiftUI

// MARK: - Avatar Variants
enum AvatarVariant: Equatable {
    case `default`(size: CGFloat = 40)
    case online(size: CGFloat = 40)
    case idle(size: CGFloat = 40)
    case group(size: CGFloat = 40)
    case initials(size: CGFloat = 40)
    case icon(size: CGFloat = 40)
    case size24
    case size32
    case size80
    case size160
    case size32Icon
    
    var size: CGFloat {
        switch self {
        case .default(let size), .online(let size), .idle(let size), .group(let size), .initials(let size), .icon(let size):
            return size
        case .size24:
            return 24
        case .size32, .size32Icon:
            return 32
        case .size80:
            return 80
        case .size160:
            return 160
        }
    }
}

struct Avatar: View {
    let initials: String?
    let imageName: String?
    let variant: AvatarVariant
    let isOnline: Bool
    let imageIndex: Int? // For Unsplash integration
    let secondImageIndex: Int? // For group avatars - second image
    
    @ObservedObject private var unsplashService = UnsplashService.shared
    
    init(initials: String? = nil, imageName: String? = nil, variant: AvatarVariant = .default(), isOnline: Bool = false, imageIndex: Int? = nil, secondImageIndex: Int? = nil) {
        self.initials = initials
        self.imageName = imageName
        self.variant = variant
        self.isOnline = isOnline
        self.imageIndex = imageIndex
        self.secondImageIndex = secondImageIndex
    }
    
    // Convenience initializers for backward compatibility
    init(initials: String? = nil, imageName: String? = nil, size: CGFloat = 24, isOnline: Bool = false) {
        self.initials = initials
        self.imageName = imageName
        self.variant = .default(size: size)
        self.isOnline = isOnline
        self.imageIndex = nil
        self.secondImageIndex = nil
    }
    
    // Computed property to extract first two initials from a full name
    private var processedInitials: String? {
        guard let initials = initials else { return nil }
        
        // Clean the input - remove extra whitespace and normalize
        let cleanedName = initials.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // If it's already 2 characters or less, return as is
        if cleanedName.count <= 2 {
            return cleanedName.uppercased()
        }
        
        // Split by spaces, hyphens, and other common separators
        let separators = CharacterSet(charactersIn: " -_.,")
        let nameParts = cleanedName.components(separatedBy: separators)
            .filter { !$0.isEmpty && $0.count > 0 }
        
        // If we have at least 2 parts, take first letter of first and last
        if nameParts.count >= 2 {
            let firstPart = nameParts.first ?? ""
            let lastPart = nameParts.last ?? ""
            
            // Extract first letter from each part, handling emojis and special characters
            let firstInitial = extractFirstLetter(from: firstPart)
            let lastInitial = extractFirstLetter(from: lastPart)
            
            if !firstInitial.isEmpty && !lastInitial.isEmpty {
                return (firstInitial + lastInitial).uppercased()
            } else if !firstInitial.isEmpty {
                return firstInitial.uppercased()
            }
        }
        
        // If we only have one part, take first two characters
        if nameParts.count == 1 {
            let name = nameParts[0]
            let firstLetter = extractFirstLetter(from: name)
            if firstLetter.count >= 2 {
                return String(firstLetter.prefix(2)).uppercased()
            } else if !firstLetter.isEmpty {
                return firstLetter.uppercased()
            }
        }
        
        // Fallback: take first two characters of the original string
        let fallbackInitials = String(cleanedName.prefix(2))
        return fallbackInitials.uppercased()
    }
    
    // Helper function to extract the first letter from a string, handling emojis and special characters
    private func extractFirstLetter(from string: String) -> String {
        // Remove leading whitespace
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle empty strings
        guard !trimmed.isEmpty else { return "" }
        
        // For strings that start with emojis or special characters, take the first character
        if trimmed.first?.isLetter == false {
            return String(trimmed.prefix(1))
        }
        
        // For regular text, find the first letter
        for char in trimmed {
            if char.isLetter {
                return String(char)
            }
        }
        
        // If no letter found, return the first character
        return String(trimmed.prefix(1))
    }
    
    // Improved color palette with better accessibility and contrast
    private let colors = [
        Color(red: 0.345, green: 0.145, blue: 0.565), // Deep Purple - better contrast
        Color(red: 0.545, green: 0.149, blue: 0.580), // Rich Pink - better contrast
        Color(red: 0.580, green: 0.133, blue: 0.392), // Deep Magenta - better contrast
        Color(red: 0.110, green: 0.310, blue: 0.447), // Deep Blue - better contrast
        Color(red: 0.086, green: 0.290, blue: 0.322), // Deep Teal - better contrast
        Color(red: 0.176, green: 0.322, blue: 0.086), // Deep Green - better contrast
        Color(red: 0.565, green: 0.145, blue: 0.145), // Deep Red - new addition
        Color(red: 0.565, green: 0.345, blue: 0.145), // Deep Orange - new addition
        Color(red: 0.145, green: 0.565, blue: 0.345), // Deep Mint - new addition
        Color(red: 0.345, green: 0.145, blue: 0.565)  // Deep Indigo - new addition
    ]
    
    private var avatarColor: Color {
        guard let processedInitials = processedInitials else { return .secondary.opacity(0.3) }
        let hash = processedInitials.hashValue
        return colors[abs(hash) % colors.count]
    }
    
    // Generate a different color for the second avatar in group chats
    private func generateSecondAvatarColor(from initials: String) -> Color {
        // Use a different hash calculation to get a different color
        let modifiedInitials = initials + "_second"
        let hash = modifiedInitials.hashValue
        return colors[abs(hash) % colors.count]
    }
    
    private var fontSize: CGFloat {
        switch variant {
        case .size24:
            return 11
        case .size32, .size32Icon:
            return 12
        case .size80:
            return 34
        case .size160:
            return 73
        default:
            return variant.size * 0.46 // Default scaling
        }
    }
    
    private var iconFontSize: CGFloat {
        switch variant {
        case .size32Icon:
            return 15
        default:
            return variant.size * 0.4
        }
    }
    
    
    var body: some View {
        Group {
            switch variant {
            case .group:
                groupAvatarView
            case .initials:
                initialsAvatarView
            case .icon:
                iconAvatarView
            case .online:
                onlineAvatarView
            case .idle:
                idleAvatarView
            case .size24, .size32, .size80, .size160, .size32Icon:
                sizedAvatarView
            case .default:
                defaultAvatarView
            }
        }
    }
    
    // MARK: - Avatar Views
    
    private var groupAvatarView: some View {
        ZStack {
            // First avatar (background) - top left
            firstGroupAvatarImage
                .frame(width: variant.size * 0.7, height: variant.size * 0.7)
                .offset(x: -variant.size * 0.15, y: -variant.size * 0.15)
            
            // Second avatar (foreground) - bottom right with stroke
            ZStack {
                // White stroke background - extends beyond avatar boundary
                Circle()
                    .fill(Color.white)
                    .frame(width: variant.size * 0.7 + 4, height: variant.size * 0.7 + 4)
                
                // Second avatar image
                secondGroupAvatarImage
                    .frame(width: variant.size * 0.7, height: variant.size * 0.7)
            }
            .offset(x: variant.size * 0.15, y: variant.size * 0.15)
        }
        .frame(width: variant.size, height: variant.size)
    }
    
    private var initialsAvatarView: some View {
        ZStack {
            avatarImage
                .frame(width: variant.size, height: variant.size)
            
            if let processedInitials = processedInitials {
                Text(processedInitials)
                    .font(.system(size: fontSize, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
    
    private var iconAvatarView: some View {
        ZStack {
            avatarImage
                .frame(width: variant.size, height: variant.size)
            
            Image(systemName: "person.fill")
                .font(.system(size: iconFontSize, weight: .regular))
                .foregroundColor(Color(red: 0.94, green: 0.95, blue: 0.96)) // #f0f3f5
        }
    }
    
    private var onlineAvatarView: some View {
        ZStack {
            avatarImage
                .frame(width: variant.size, height: variant.size)
            
            // Online status indicator with stroke outline
            ZStack {
                // White stroke background (12px total)
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                
                // Green indicator (8px)
                Circle()
                    .fill(Color(red: 0, green: 0.54, blue: 0.18)) // #008a2f
                    .frame(width: 8, height: 8)
            }
            .offset(x: variant.size * 0.35, y: variant.size * 0.35)
        }
    }
    
    private var idleAvatarView: some View {
        ZStack {
            avatarImage
                .frame(width: variant.size, height: variant.size)
            
            // Idle status indicator with stroke outline
            ZStack {
                // White stroke background (12px total)
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                
                // Yellow indicator (8px)
                Circle()
                    .fill(Color(red: 0.96, green: 0.65, blue: 0.03)) // #f5a607
                    .frame(width: 8, height: 8)
            }
            .offset(x: variant.size * 0.35, y: variant.size * 0.35)
        }
    }
    
    private var sizedAvatarView: some View {
        ZStack {
            avatarImage
                .frame(width: variant.size, height: variant.size)
            
            switch variant {
            case .size32Icon:
                Image(systemName: "person.fill")
                    .font(.system(size: iconFontSize, weight: .regular))
                    .foregroundColor(Color(red: 0.94, green: 0.95, blue: 0.96)) // #f0f3f5
            default:
                if let processedInitials = processedInitials {
                    Text(processedInitials)
                        .font(.system(size: fontSize, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var defaultAvatarView: some View {
        avatarImage
            .frame(width: variant.size, height: variant.size)
    }
    
    // MARK: - Avatar Image Logic
    
    private var avatarImage: some View {
        Group {
            if let imageName = imageName {
                // Use provided image name
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if let imageIndex = imageIndex, 
                      let photo = unsplashService.getPhoto(at: imageIndex) {
                // Use Unsplash image
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    // Fallback to initials while loading
                    Circle()
                        .fill(avatarColor)
                        .overlay(
                            Group {
                                if let processedInitials = processedInitials {
                                    Text(processedInitials)
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                }
            } else if let processedInitials = processedInitials {
                // Use initials
                Circle()
                    .fill(avatarColor)
                    .overlay(
                        Text(processedInitials)
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.white)
                    )
            } else {
                // Fallback avatar
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    )
            }
        }
    }
    
    // MARK: - Group Avatar Images
    
    private var firstGroupAvatarImage: some View {
        Group {
            if let imageName = imageName {
                // Use provided image name
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if let imageIndex = imageIndex, 
                      let photo = unsplashService.getPhoto(at: imageIndex) {
                // Use Unsplash image
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    // Fallback to initials while loading
                    Circle()
                        .fill(avatarColor)
                        .overlay(
                            Group {
                                if let processedInitials = processedInitials {
                                    Text(processedInitials)
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                }
            } else if let processedInitials = processedInitials {
                // Use initials
                Circle()
                    .fill(avatarColor)
                    .overlay(
                        Text(processedInitials)
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.white)
                    )
            } else {
                // Fallback avatar
                Circle()
                    .fill(.secondary.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.secondary)
                    )
            }
        }
    }
    
    private var secondGroupAvatarImage: some View {
        Group {
            if let secondImageIndex = secondImageIndex, 
                      let photo = unsplashService.getPhoto(at: secondImageIndex) {
                // Use second Unsplash image
                AsyncImage(url: URL(string: photo.urls.small)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } placeholder: {
                    // Fallback to initials while loading
                    Circle()
                        .fill(avatarColor)
                        .overlay(
                            Group {
                                if let processedInitials = processedInitials {
                                    Text(processedInitials)
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: fontSize, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                        )
                }
            } else if let processedInitials = processedInitials {
                // Use initials with different color for second avatar
                // Generate a different color for the second avatar based on initials + offset
                let secondAvatarColor = generateSecondAvatarColor(from: processedInitials)
                Circle()
                    .fill(secondAvatarColor)
                    .overlay(
                        Text(processedInitials)
                            .font(.system(size: fontSize, weight: .medium))
                            .foregroundColor(.white)
                    )
            } else {
                // Fallback avatar
                Circle()
                    .fill(.secondary.opacity(0.3))
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
    ScrollView {
        VStack(spacing: 24) {
            // Default variants
            VStack(alignment: .leading, spacing: 12) {
                Text("Default Variants")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Avatar(initials: "Alex", variant: .default())
                    Avatar(initials: "Maria", variant: .online())
                    Avatar(initials: "David", variant: .idle())
                    Avatar(initials: "Sarah", variant: .initials())
                    Avatar(initials: "John", variant: .icon())
                }
            }
            
            // Size variants
            VStack(alignment: .leading, spacing: 12) {
                Text("Size Variants")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Avatar(initials: "AA", variant: .size24)
                    Avatar(initials: "BB", variant: .size32)
                    Avatar(initials: "CC", variant: .size80)
                    Avatar(initials: "DD", variant: .size160)
                }
            }
            
            // Group variant
            VStack(alignment: .leading, spacing: 12) {
                Text("Group Variant")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Avatar(initials: "Group", variant: .group())
                    Avatar(initials: "Team", variant: .group())
                }
            }
            
            // Unsplash integration
            VStack(alignment: .leading, spacing: 12) {
                Text("Unsplash Integration")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Avatar(initials: "Alex", variant: .default(), imageIndex: 0)
                    Avatar(initials: "Maria", variant: .online(), imageIndex: 1)
                    Avatar(initials: "David", variant: .idle(), imageIndex: 2)
                    Avatar(initials: "Sarah", variant: .initials(), imageIndex: 3)
                }
            }
            
            // Icon variants
            VStack(alignment: .leading, spacing: 12) {
                Text("Icon Variants")
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Avatar(initials: "User", variant: .icon())
                    Avatar(initials: "Admin", variant: .size32Icon)
                }
            }
        }
        .padding()
    }
}
