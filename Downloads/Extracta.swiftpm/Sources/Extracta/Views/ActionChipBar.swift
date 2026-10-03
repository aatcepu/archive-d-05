// ActionChipBar.swift
// Extracta — Horizontal scrolling row of entity action chips

import SwiftUI

/// Shows tappable chips for detected entities (non-plain items only).
/// Appears below the screenshot card after sweep completion.
struct ActionChipBar: View {
    let items: [ExtractedItem]
    let onAction: (ExtractedItem) -> Void
    let onCopy: (ExtractedItem) -> Void

    /// Only show chips for semantically meaningful entities, not plain text.
    private var entityItems: [ExtractedItem] {
        items.filter { $0.entityType != .plain }
    }

    var body: some View {
        if !entityItems.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(entityItems.enumerated()), id: \.element.id) { index, item in
                        EntityChip(item: item) {
                            onAction(item)
                        } onCopy: {
                            onCopy(item)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(
                            .spring(response: 0.45, dampingFraction: 0.75)
                                .delay(Double(index) * 0.05),
                            value: entityItems.count
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
}
