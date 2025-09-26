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
    
    // MARK: - Simple Color System
    // Using system colors directly - no complex adaptive logic needed
}