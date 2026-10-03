// ImageProcessor.swift
// Extracta — Image geometry and processing utilities

import UIKit

enum ImageProcessor {

    /// Compute the rendered rect of an image displayed with `.fit` content mode
    /// within a container of the given size. Returns origin + size of the image
    /// within the container coordinate space.
    static func fittedRect(imageSize: CGSize, in containerSize: CGSize) -> CGRect {
        guard imageSize.width > 0, imageSize.height > 0,
              containerSize.width > 0, containerSize.height > 0 else {
            return CGRect(origin: .zero, size: containerSize)
        }

        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height

        let fittedSize: CGSize
        if imageAspect > containerAspect {
            // Image is wider — width fills, height is centred
            fittedSize = CGSize(
                width: containerSize.width,
                height: containerSize.width / imageAspect
            )
        } else {
            // Image is taller — height fills, width is centred
            fittedSize = CGSize(
                width: containerSize.height * imageAspect,
                height: containerSize.height
            )
        }

        let origin = CGPoint(
            x: (containerSize.width - fittedSize.width) / 2,
            y: (containerSize.height - fittedSize.height) / 2
        )

        return CGRect(origin: origin, size: fittedSize)
    }

    /// Generate a compressed JPEG thumbnail from a UIImage.
    @MainActor
    static func thumbnail(from image: UIImage, maxDimension: CGFloat = 240) -> Data? {
        let scale = min(maxDimension / image.size.width,
                        maxDimension / image.size.height, 1.0)
        let newSize = CGSize(width: image.size.width * scale,
                             height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let thumb = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return thumb.jpegData(compressionQuality: 0.6)
    }
}
