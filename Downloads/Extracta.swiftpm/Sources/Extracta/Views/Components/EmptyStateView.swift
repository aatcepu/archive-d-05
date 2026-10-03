// EmptyStateView.swift
// Extracta — Reusable empty/error state component

import SwiftUI

/// A centred empty-state placeholder with icon, title, and message.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
        }
        .padding()
        .accessibilityElement(children: .combine)
    }
}
