//
//  SwitchCommunitySheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SwitchCommunitySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedTintColor: Color
    @State private var redValue: Double = 0.0
    @State private var greenValue: Double = 0.0
    @State private var blueValue: Double = 1.0
    
    var body: some View {
        SheetTemplate(title: "Switch Community") {
            VStack(spacing: 24) {
                Spacer(minLength: 20)
                
                // Color preview
                VStack(spacing: 12) {
                    Text("Color Preview")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    // Overlapping ellipses showing contrast
                    ZStack {
                        // Original color ellipse (bottom layer)
                        Circle()
                            .fill(currentColor)
                            .frame(width: 120, height: 120)
                            .offset(x: 15, y: 0)
                        
                        // Primary color ellipse (top layer)
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 120, height: 120)
                            .offset(x: -15, y: 0)
                    }
                    .frame(width: 180, height: 120)
                    
                    // Labels
                    HStack(spacing: 40) {
                        VStack(spacing: 2) {
                            Text("Original")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 2) {
                            Text("Adaptive")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                // RGB sliders
                VStack(spacing: 16) {
                    Text("RGB Color Picker")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    VStack(spacing: 12) {
                        // Red slider
                        HStack {
                            Text("Red")
                                .frame(width: 40, alignment: .leading)
                                .font(.subheadline)
                            Slider(value: $redValue, in: 0...1)
                                .tint(.red)
                            Text("\(Int(redValue * 255))")
                                .frame(width: 30, alignment: .trailing)
                                .font(.caption.monospacedDigit())
                        }
                        
                        // Green slider
                        HStack {
                            Text("Green")
                                .frame(width: 40, alignment: .leading)
                                .font(.subheadline)
                            Slider(value: $greenValue, in: 0...1)
                                .tint(.green)
                            Text("\(Int(greenValue * 255))")
                                .frame(width: 30, alignment: .trailing)
                                .font(.caption.monospacedDigit())
                        }
                        
                        // Blue slider
                        HStack {
                            Text("Blue")
                                .frame(width: 40, alignment: .leading)
                                .font(.subheadline)
                            Slider(value: $blueValue, in: 0...1)
                                .tint(.blue)
                            Text("\(Int(blueValue * 255))")
                                .frame(width: 30, alignment: .trailing)
                                .font(.caption.monospacedDigit())
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Close button
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 20)
                
                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .onAppear {
            // Initialize sliders with current color
            let uiColor = UIColor(selectedTintColor)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            redValue = Double(red)
            greenValue = Double(green)
            blueValue = Double(blue)
        }
        .onChange(of: redValue) { _, _ in
            selectedTintColor = Color.primary
        }
        .onChange(of: greenValue) { _, _ in
            selectedTintColor = Color.primary
        }
        .onChange(of: blueValue) { _, _ in
            selectedTintColor = Color.primary
        }
    }
    
    private var currentColor: Color {
        Color(red: redValue, green: greenValue, blue: blueValue)
    }
}

#Preview {
    SwitchCommunitySheet(selectedTintColor: .constant(Color.blue))
}
