// EntityOverlay.swift
// Extracta — Single bounding box overlay for a detected entity

import SwiftUI

/// Draws a colour-coded rounded rectangle for one recognised text region.
struct EntityOverlay: View {
    let item: ExtractedItem
    let onTap: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(item.entityType.color.opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(item.entityType.color.opacity(0.6), lineWidth: 1.5)
            )
            .onTapGesture(perform: onTap)
            .accessibilityLabel("\(item.entityType.displayName): \(item.text)")
            .accessibilityAddTraits(.isButton)
    }
}
