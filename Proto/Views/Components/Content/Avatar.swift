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
    
    @StateObject private var unsplashService = UnsplashService.shared
    
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
                    .font(.system(size: fontSize, weight: .regular))
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
                let secondAvatarColor = Color(red: 0.702, green: 0.192, blue: 0.745) // Pink
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
