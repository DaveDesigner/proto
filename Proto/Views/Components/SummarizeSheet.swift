//
//  SummarizeSheet.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct SummarizeSheet: View {
    @State private var isLoading = true
    
    var body: some View {
        SheetTemplate {
            ScrollView {
                VStack(spacing: 0) {
                    // Custom title
                    Text("Summarize")
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    
                    // Skeleton loading content
                    if isLoading {
                        VStack(spacing: 12) {
                            // Skeleton text line 1 - full width (heading)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            
                            // Skeleton text line 2 - 85% width
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 40) // This creates the 85% effect
                            
                            // Skeleton text line 3 - 65% width
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 80) // This creates the 65% effect
                            
                            // Skeleton text line 4 - 95% width
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 10) // This creates the 95% effect
                            
                            // Skeleton text line 5 - 45% width (short)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.trailing, 100) // This creates the 45% effect
                            

                        }
                        .overlay(
                            // Shimmer effect overlay
                            ShimmerEffect()
                        )
                        .onAppear {
                            // Simulate loading process
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isLoading = false
                                }
                            }
                        }
                    } else {
                        // Content when loading is complete
                        VStack(spacing: 16) {
                            Text("Summarization complete!")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            Text("Your content has been analyzed and summarized.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
        }
    }
}

#Preview {
    SummarizeSheet()
}
