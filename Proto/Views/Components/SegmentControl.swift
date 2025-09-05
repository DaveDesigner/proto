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
    
    init(segments: [String], selectedIndex: Binding<Int>, onSelectionChanged: @escaping (Int) -> Void = { _ in }) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.onSelectionChanged = onSelectionChanged
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
    }
    
    private func segmentButton(for index: Int) -> some View {
        let isSelected = selectedIndex == index
        
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedIndex = index
                onSelectionChanged(index)
            }
        }) {
            Text(segments[index])
                .font(.subheadline.weight(.semibold))
                .foregroundColor(isSelected ? .white : .secondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .glassEffect(isSelected ? .regular.tint(.accentColor).interactive() : .regular.interactive())
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
