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
    
    // MARK: - Additional Design System Colors
    // Add more colors from your Figma spec as needed
    
    /// Background color for the app
    static let systemBackgroundPrimary = Color(uiColor: .systemBackground)
    static let systemBackgroundSecondary = Color(uiColor: .secondarySystemBackground)
    static let systemBackgroundTertiary = Color(uiColor: .tertiarySystemBackground)
}