// EntityChip.swift
// Extracta — Tap-to-act chip for a detected entity

import SwiftUI

/// An action chip showing entity icon + text, colour-coded by type.
/// Tap to perform the primary action; long-press / context menu to copy.
struct EntityChip: View {
    let item: ExtractedItem
    let onTap: () -> Void
    let onCopy: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: item.entityType.icon)
                    .font(.system(size: 12, weight: .semibold))

                Text(item.text)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(item.entityType.color.opacity(0.12))
            .foregroundStyle(item.entityType.color)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(item.entityType.color.opacity(0.3), lineWidth: 1)
            )
        }
        .accessibilityLabel("\(item.entityType.displayName): \(item.text)")
        .accessibilityHint("Tap to use, long press to copy")
        .contextMenu {
            Button {
                onCopy()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
        }
    }
}
