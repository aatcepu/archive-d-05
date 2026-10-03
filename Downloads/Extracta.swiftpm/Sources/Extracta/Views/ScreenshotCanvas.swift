// ScreenshotCanvas.swift
// Extracta — Screenshot canvas with sweep gesture, OCR overlays, and action chips
// Card geometry and placeholder generator preserved from original implementation.

import SwiftUI
import UIKit

struct ScreenshotCanvas: View {

    @ObservedObject var viewModel: CanvasViewModel
    @Environment(\.horizontalSizeClass) private var hSizeClass

    // ── Body ─────────────────────────────────────────────────────────────

    var body: some View {
        GeometryReader { geo in
            let isRegular = hSizeClass == .regular
            let cardSize  = canvasRect(in: geo.size, regular: isRegular)
            let padding: CGFloat = isRegular ? 16 : 10
            let cornerRadius: CGFloat = isRegular ? 20 : 14

            // Compute the actual rendered image rect within the padded card
            let imageContainerSize = CGSize(
                width:  cardSize.width  - padding * 2,
                height: cardSize.height - padding * 2
            )
            let imageRect = ImageProcessor.fittedRect(
                imageSize: displayUIImage.size,
                in: imageContainerSize
            )

            VStack(spacing: 12) {
                Spacer(minLength: 0)

                // ── Image card ──────────────────────────────────────────
                ZStack {
                    // Card background
                    RoundedRectangle(cornerRadius: isRegular ? 24 : 18,
                                     style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.12),
                                radius: isRegular ? 24 : 14, x: 0, y: 6)

                    // Screenshot image
                    displayImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius,
                                                   style: .continuous))
                        .padding(padding)

                    // Bounding box overlays (appear after extraction completes)
                    if viewModel.didCompleteSweep
                        && !viewModel.extractedItems.isEmpty {
                        BoundingBoxOverlay(
                            items: viewModel.extractedItems,
                            imageSize: imageRect.size,
                            onTap: { viewModel.selectedItem = $0 }
                        )
                        .frame(width: imageRect.size.width,
                               height: imageRect.size.height)
                        .clipShape(
                            RoundedRectangle(cornerRadius: cornerRadius,
                                            style: .continuous)
                        )
                    }

                    // Sweep gesture overlay (on top of everything)
                    SweepOverlay(canvasSize: cardSize, viewModel: viewModel)
                }
                .frame(width: cardSize.width, height: cardSize.height)

                // ── Action chips ────────────────────────────────────────
                if viewModel.didCompleteSweep
                    && !viewModel.extractedItems.isEmpty {
                    ActionChipBar(
                        items: viewModel.extractedItems,
                        onAction: { viewModel.performAction(for: $0) },
                        onCopy: { viewModel.copyText($0.text) }
                    )
                    .frame(maxWidth: cardSize.width)
                }

                // ── Status indicators ───────────────────────────────────
                if viewModel.isExtracting {
                    HStack(spacing: 8) {
                        ProgressView()
                            .controlSize(.small)
                        Text("Extracting text…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity)
                }

                if viewModel.didCompleteSweep
                    && !viewModel.isExtracting
                    && viewModel.extractedItems.isEmpty {
                    Text("No text detected in this image.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            // Set the placeholder as the default image so OCR works
            // immediately without needing Photos access.
            if viewModel.currentImage == nil {
                viewModel.currentImage = Self.placeholder
            }
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────

    /// Cached placeholder — generated once, reused across re-renders.
    private static let placeholder = generatePlaceholder()

    private var displayUIImage: UIImage {
        viewModel.currentImage ?? Self.placeholder
    }

    private var displayImage: Image {
        Image(uiImage: displayUIImage)
    }

    /// Card geometry — preserved from original implementation.
    private func canvasRect(in available: CGSize, regular: Bool) -> CGSize {
        let hPad: CGFloat = regular ? 120 : 32
        let vPad: CGFloat = regular ? 80  : 48
        let maxW = available.width  - hPad
        let maxH = available.height - vPad
        let clampedW = min(maxW, regular ? 680 : maxW)
        let aspect: CGFloat = 3.0 / 5.0
        let cardH = min(maxH, clampedW / aspect)
        let cardW = cardH * aspect
        return CGSize(width: cardW, height: cardH)
    }

    // ── Placeholder screenshot generator (preserved & enhanced) ─────────
    // Includes diverse entity types (email, phone, date, URL, address)
    // so the demo works immediately without Photos access.

    @MainActor
    private static func generatePlaceholder(
        size: CGSize = CGSize(width: 390, height: 650)
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let bounds = CGRect(origin: .zero, size: size)

            // Background
            UIColor.systemBackground.setFill()
            UIBezierPath(roundedRect: bounds, cornerRadius: 0).fill()

            // Status bar area
            UIColor.systemGray5.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0,
                                     width: size.width, height: 44)).fill()

            // Title bar
            UIColor.systemGray6.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 44,
                                     width: size.width, height: 44)).fill()

            let titleAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                .foregroundColor: UIColor.label
            ]
            NSAttributedString(string: "Lecture Notes — CS401",
                               attributes: titleAttr)
                .drawCentered(in: CGRect(x: 0, y: 44,
                                        width: size.width, height: 44))

            // Content rows — diverse entity types for demo
            let rowAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]
            let rows = [
                "📧  priya.sharma@university.edu",
                "📞  +91 98765 43210",
                "🗓  Team standup at 10:00 AM tomorrow",
                "🔗  https://canvas.university.edu/cs401",
                "📍  Room 204, Engineering Building",
                "📦  Deploy release candidate by Friday",
                "📝  Review PR #42 before EOD",
            ]
            var y: CGFloat = 110
            for row in rows {
                NSAttributedString(string: row, attributes: rowAttr)
                    .draw(at: CGPoint(x: 20, y: y))
                let sep = UIBezierPath()
                sep.move(to:    CGPoint(x: 20,              y: y + 24))
                sep.addLine(to: CGPoint(x: size.width - 20, y: y + 24))
                sep.lineWidth = 0.5
                UIColor.separator.setStroke()
                sep.stroke()
                y += 40
            }

            // Hint at bottom
            NSAttributedString(
                string: "Sweep to extract →",
                attributes: [
                    .font: UIFont.italicSystemFont(ofSize: 12),
                    .foregroundColor: UIColor.tertiaryLabel
                ]
            ).drawCentered(in: CGRect(x: 0, y: size.height - 40,
                                     width: size.width, height: 30))
        }
    }
}

// ── NSAttributedString drawing helper (preserved from original) ──────────────

private extension NSAttributedString {
    func drawCentered(in rect: CGRect) {
        let s = self.size()
        draw(at: CGPoint(
            x: rect.minX + (rect.width  - s.width)  / 2,
            y: rect.minY + (rect.height - s.height) / 2
        ))
    }
}
