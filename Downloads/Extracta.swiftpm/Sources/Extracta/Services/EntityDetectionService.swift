// EntityDetectionService.swift
// Extracta — Semantic entity classification using NSDataDetector

import Foundation

/// Classifies OCR text fragments into semantic entity types
/// (phone, date, URL, address, email) using NSDataDetector and regex.
/// Pure Foundation — no ML model, no network.
enum EntityDetectionService {

    /// Classify a single text fragment and return an ExtractedItem.
    static func classify(_ text: String, normalizedBounds: CGRect) -> ExtractedItem {
        // 1. Email check — NSDataDetector lacks a dedicated email type
        let emailPattern = #"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
        if text.range(of: emailPattern, options: .regularExpression) != nil {
            return ExtractedItem(
                text: text, entityType: .email, normalizedBounds: normalizedBounds
            )
        }

        // 2. NSDataDetector for phone, date, URL, address
        let types: NSTextCheckingResult.CheckingType = [
            .phoneNumber, .date, .link, .address
        ]
        guard let detector = try? NSDataDetector(types: types.rawValue) else {
            return ExtractedItem(
                text: text, entityType: .plain, normalizedBounds: normalizedBounds
            )
        }

        let range = NSRange(text.startIndex..., in: text)
        let matches = detector.matches(in: text, options: [], range: range)

        for match in matches {
            switch match.resultType {
            case .phoneNumber:
                return ExtractedItem(
                    text: text, entityType: .phoneNumber,
                    normalizedBounds: normalizedBounds
                )
            case .date:
                return ExtractedItem(
                    text: text, entityType: .date,
                    normalizedBounds: normalizedBounds
                )
            case .link:
                return ExtractedItem(
                    text: text, entityType: .url,
                    normalizedBounds: normalizedBounds
                )
            case .address:
                return ExtractedItem(
                    text: text, entityType: .address,
                    normalizedBounds: normalizedBounds
                )
            default:
                break
            }
        }

        return ExtractedItem(
            text: text, entityType: .plain, normalizedBounds: normalizedBounds
        )
    }

    /// Classify all OCR observations into ExtractedItems.
    static func process(observations: [OCRService.Observation]) -> [ExtractedItem] {
        observations.compactMap { obs in
            let text = obs.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { return nil }
            return classify(text, normalizedBounds: obs.normalizedBounds)
        }
    }
}
