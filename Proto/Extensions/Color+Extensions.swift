import SwiftUI

extension Color {
    // MARK: - Semantic Colors from Figma Design System
    
    /// Primary color from design system
    /// Light mode: #191b1f (dark text)
    /// Dark mode: #f0f3f5 (light text)
    /// Use for main text, headings, and primary UI elements
    static let primary = Color("ColourPrimary")
    
    /// Secondary color from design system
    /// Light mode: #42464d (medium text)
    /// Dark mode: #c9cbce (medium text)
    /// Use for secondary text and UI elements
    static let secondary = Color("ColourSecondary")
    
    /// Tertiary color from design system
    /// Light mode: #717680 (light text)
    /// Dark mode: #858993 (darker text)
    /// Use for tertiary text, metadata, and subtle UI elements
    static let tertiary = Color("ColourTertiary")
    
    /// Quaternary color from design system
    /// Light mode: #90929d (quaternary text)
    /// Dark mode: #676b74 (quaternary text)
    /// Use for quaternary text, labels, and subtle UI elements
    static let quaternary = Color("ColourQuarternary")
    
    // MARK: - Notification Badge Colors
    // Note: notificationRed, notificationOrange, notificationTeal, and notificationYellow
    // are automatically generated from the asset catalog
    
    /// Purple color for AI and reply notification badges
    /// #9676f8 - Messaging/Ai primary from Figma
    static let notificationPurple = Color(red: 0.59, green: 0.46, blue: 0.97)
    
    // MARK: - Additional Design System Colors
    // Add more colors from your Figma spec as needed
    
    /// Background color for the app
    static let systemBackgroundPrimary = Color(uiColor: .systemBackground)
    static let systemBackgroundSecondary = Color(uiColor: .secondarySystemBackground)
    static let systemBackgroundTertiary = Color(uiColor: .tertiarySystemBackground)
    
    // MARK: - Adaptive Community Colors
    
    /// Creates an adaptive color that automatically adjusts for light and dark themes
    /// - Parameters:
    ///   - lightColor: Color to use in light mode
    ///   - darkColor: Color to use in dark mode
    /// - Returns: A color that adapts to the current color scheme
    static func adaptive(light lightColor: Color, dark darkColor: Color) -> Color {
        Color(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(darkColor)
            case .light, .unspecified:
                return UIColor(lightColor)
            @unknown default:
                return UIColor(lightColor)
            }
        })
    }
    
    /// Generates an adaptive community color that automatically adjusts brightness for optimal visibility
    /// - Parameter baseColor: The base community color to adapt
    /// - Returns: An adaptive color that's optimized for both light and dark themes
    static func adaptiveCommunity(_ baseColor: Color) -> Color {
        let uiColor = UIColor(baseColor)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate brightness using standard luminance formula
        let brightness = (red * 0.299 + green * 0.587 + blue * 0.114)
        
        // For light mode: if the color is too bright, darken it
        // For dark mode: if the color is too dark, brighten it
        let lightModeColor: Color
        let darkModeColor: Color
        
        if brightness > 0.6 {
            // Color is bright - use darker variant for light mode, original for dark mode
            lightModeColor = Color(red: red * 0.7, green: green * 0.7, blue: blue * 0.7, opacity: alpha)
            darkModeColor = baseColor
        } else if brightness < 0.3 {
            // Color is dark - use original for light mode, brighter variant for dark mode
            lightModeColor = baseColor
            darkModeColor = Color(red: min(1.0, red * 1.4), green: min(1.0, green * 1.4), blue: min(1.0, blue * 1.4), opacity: alpha)
        } else {
            // Color is in middle range - use slight adjustments
            lightModeColor = Color(red: red * 0.85, green: green * 0.85, blue: blue * 0.85, opacity: alpha)
            darkModeColor = Color(red: min(1.0, red * 1.2), green: min(1.0, green * 1.2), blue: min(1.0, blue * 1.2), opacity: alpha)
        }
        
        return adaptive(light: lightModeColor, dark: darkModeColor)
    }
    
    /// Generates a random community color that's already optimized for both light and dark themes
    /// - Returns: A random adaptive community color
    static func randomAdaptiveCommunity() -> Color {
        let randomColor = Color(
            red: Double.random(in: 0.2...0.8),
            green: Double.random(in: 0.2...0.8),
            blue: Double.random(in: 0.2...0.8)
        )
        return adaptiveCommunity(randomColor)
    }
}