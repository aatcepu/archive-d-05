// BoundingBoxOverlay.swift
// Extracta — Visual overlay drawing detected text regions onto the image

import SwiftUI

/// Draws colour-coded bounding boxes for all extracted items,
/// positioned to align with the displayed image. Each box is an
/// EntityOverlay component.
struct BoundingBoxOverlay: View {
    let items: [ExtractedItem]
    let imageSize: CGSize          // Rendered image size in points
    let onTap: (ExtractedItem) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let rect = convertBounds(item.normalizedBounds)

                EntityOverlay(item: item) {
                    onTap(item)
                }
                .frame(width: max(rect.width, 4), height: max(rect.height, 4))
                .offset(x: rect.minX, y: rect.minY)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.7)
                        .delay(Double(index) * 0.04),
                    value: items.count
                )
            }
        }
        .frame(width: imageSize.width, height: imageSize.height, alignment: .topLeading)
        .allowsHitTesting(true)
    }

    /// Convert Vision normalised coordinates (origin bottom-left, 0–1)
    /// to SwiftUI coordinates (origin top-left, pixel dimensions).
    private func convertBounds(_ normalized: CGRect) -> CGRect {
        CGRect(
            x: normalized.minX * imageSize.width,
            y: (1 - normalized.maxY) * imageSize.height,
            width: normalized.width * imageSize.width,
            height: normalized.height * imageSize.height
        )
    }
}
