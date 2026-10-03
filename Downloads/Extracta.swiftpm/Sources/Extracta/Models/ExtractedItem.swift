// ExtractedItem.swift
// Extracta — A single text fragment extracted via Vision OCR

import Foundation

/// One recognised text region from a screenshot, optionally classified
/// as a semantic entity (phone, date, URL, etc.).
struct ExtractedItem: Identifiable, Sendable {
    let id: UUID
    let text: String
    let entityType: EntityType
    /// Vision coordinate space: origin at bottom-left, values 0–1.
    let normalizedBounds: CGRect

    init(
        id: UUID = UUID(),
        text: String,
        entityType: EntityType = .plain,
        normalizedBounds: CGRect = .zero
    ) {
        self.id = id
        self.text = text
        self.entityType = entityType
        self.normalizedBounds = normalizedBounds
    }
}
