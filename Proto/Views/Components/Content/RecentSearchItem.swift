//
//  RecentSearchItem.swift
//  Proto
//
//  Created by Dave Morgan on 28/08/2025.
//

import SwiftUI

struct RecentSearchItem: View {
    let searchText: String
    let onTap: (() -> Void)?
    let onRemove: (() -> Void)?
    
    init(searchText: String, onTap: (() -> Void)? = nil, onRemove: (() -> Void)? = nil) {
        self.searchText = searchText
        self.onTap = onTap
        self.onRemove = onRemove
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: 12) {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.quaternary)
                    .frame(width: 24, height: 24)
                
                // Search text
                Text(searchText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Remove button
                Button(action: {
                    onRemove?()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.quaternary)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 0) {
        RecentSearchItem(
            searchText: "Fun camping ideas",
            onTap: { print("Tapped recent search") },
            onRemove: { print("Remove recent search") }
        )
        
        Divider()
            .padding(.leading, 56)
        
        RecentSearchItem(
            searchText: "iOS development tips",
            onTap: { print("Tapped recent search") },
            onRemove: { print("Remove recent search") }
        )
    }
    .background(Color(.systemBackground))
}
