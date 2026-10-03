// LibraryView.swift
// Extracta — Visual memory search and browse interface

import SwiftUI

struct LibraryView: View {
    @ObservedObject var viewModel: LibraryViewModel
    let onSelect: (IndexedScreenshot) -> Void

    var body: some View {
        Group {
            if viewModel.isEmpty {
                EmptyStateView(
                    icon: "rectangle.stack",
                    title: "No Screenshots Yet",
                    message: "Sweep your first screenshot to build your visual memory."
                )
            } else if viewModel.displayedScreenshots.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Results",
                    message: "Try a different search term."
                )
            } else {
                List {
                    ForEach(viewModel.displayedScreenshots) { screenshot in
                        Button {
                            onSelect(screenshot)
                        } label: {
                            screenshotRow(screenshot)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Visual Memory")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchQuery,
                    prompt: "Search extracted text…")
    }

    // ── Row ──────────────────────────────────────────────────────────────

    @ViewBuilder
    private func screenshotRow(_ screenshot: IndexedScreenshot) -> some View {
        HStack(spacing: 12) {
            if let thumb = UIImage(data: screenshot.imageData) {
                Image(uiImage: thumb)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(screenshot.rawText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    ForEach(uniqueEntityTypes(in: screenshot), id: \.self) { type in
                        Image(systemName: type.icon)
                            .font(.caption2)
                            .foregroundStyle(type.color)
                    }

                    Spacer()

                    Text(screenshot.processedDate, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Screenshot containing: \(screenshot.rawText)")
    }

    private func uniqueEntityTypes(in screenshot: IndexedScreenshot) -> [EntityType] {
        let types = Set(screenshot.extractedItems.map(\.entityType))
            .filter { $0 != .plain }
        return types.sorted { $0.rawValue < $1.rawValue }
    }
}
