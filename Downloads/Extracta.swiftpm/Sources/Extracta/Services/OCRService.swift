// OCRService.swift
// Extracta — On-device text recognition using Apple Vision

import Vision
import UIKit

/// Runs VNRecognizeTextRequest on a CGImage and returns recognised text
/// observations with their bounding boxes. Fully on-device, no network.
enum OCRService {

    /// A single recognised text region from Vision.
    struct Observation: Sendable {
        let text: String
        let normalizedBounds: CGRect   // Vision coords: origin bottom-left, 0–1
    }

    /// Perform accurate text recognition on the given image.
    /// Dispatches the Vision request to a background thread to avoid
    /// blocking the UI.
    static func recognize(from cgImage: CGImage) async -> [Observation] {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let request = VNRecognizeTextRequest()
                request.recognitionLevel = .accurate
                request.usesLanguageCorrection = true
                request.recognitionLanguages = ["en-US", "en-IN"]

                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(returning: [])
                    return
                }

                let results = (request.results ?? []).compactMap { obs -> Observation? in
                    guard let candidate = obs.topCandidates(1).first else { return nil }
                    return Observation(
                        text: candidate.string,
                        normalizedBounds: obs.boundingBox
                    )
                }

                continuation.resume(returning: results)
            }
        }
    }
}
