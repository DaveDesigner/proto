//
//  SegmentControl.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SegmentControl: View {
    let segments: [String]
    @Binding var selectedIndex: Int
    let onSelectionChanged: (Int) -> Void
    let tintColor: Color
    @Environment(\.colorScheme) private var colorScheme
    
    init(segments: [String], selectedIndex: Binding<Int>, onSelectionChanged: @escaping (Int) -> Void = { _ in }, tintColor: Color = .blue) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.onSelectionChanged = onSelectionChanged
        self.tintColor = tintColor
    }
    
    private func adaptiveTintColor() -> Color {
        // Use primary color directly - it already adapts to light/dark mode
        return Color.primary
    }
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<segments.count, id: \.self) { index in
                    segmentButton(for: index)
                }
            }
        }
        .scrollClipDisabled()
        .id("\(colorScheme)-\(tintColor)")
    }
    
    private func segmentButton(for index: Int) -> some View {
        let isSelected = selectedIndex == index
        
        // Simple text color logic - primary color inverts properly
        let textColor: Color = {
            if isSelected {
                // Primary color is dark in light mode, light in dark mode
                // So we need light text in light mode, dark text in dark mode
                return colorScheme == .light ? .white : .black
            } else {
                return .secondary
            }
        }()
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIndex = index
                onSelectionChanged(index)
            }
        }) {
            Text(segments[index])
                .font(.subheadline.weight(.semibold))
                .foregroundColor(textColor)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .glassEffect(isSelected ? .regular.tint(adaptiveTintColor()).interactive() : .regular.interactive())
        .id("\(index)-\(adaptiveTintColor())")
    }
}


// MARK: - Preview
#Preview {
    VStack(spacing: 30) {
        // Generic segment control
        VStack(alignment: .leading, spacing: 8) {
            Text("Community Segments")
                .font(.headline)
            SegmentControl(
                segments: ["Feed", "Video", "Courses", "Events", "Members", "Leaderboard"],
                selectedIndex: .constant(0)
            )
        }
        .padding()
        
        // Notifications segments
        VStack(alignment: .leading, spacing: 8) {
            Text("Notifications Segments")
                .font(.headline)
            SegmentControl(
                segments: ["Inbox", "Mentions", "Threads", "Following", "Archive"],
                selectedIndex: .constant(0)
            )
        }
        .padding()
        
        // Messages segments
        VStack(alignment: .leading, spacing: 8) {
            Text("Messages Segments")
                .font(.headline)
            SegmentControl(
                segments: ["Inbox", "Agents"],
                selectedIndex: .constant(0)
            )
        }
        .padding()
    }
}
