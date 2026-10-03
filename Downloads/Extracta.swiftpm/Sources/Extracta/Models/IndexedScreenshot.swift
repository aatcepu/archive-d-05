// IndexedScreenshot.swift
// Extracta — A processed screenshot stored in the local visual memory index

import Foundation

/// Represents a screenshot that has been swept and had its text extracted.
/// Stored in-memory for the session duration. Contains a compressed JPEG
/// thumbnail and all extracted items for search.
struct IndexedScreenshot: Identifiable, Sendable {
    let id: UUID
    let imageData: Data              // JPEG thumbnail data
    let extractedItems: [ExtractedItem]
    let rawText: String              // concatenated text for full-text search
    let processedDate: Date

    init(
        id: UUID = UUID(),
        imageData: Data,
        extractedItems: [ExtractedItem],
        processedDate: Date = Date()
    ) {
        self.id = id
        self.imageData = imageData
        self.extractedItems = extractedItems
        self.rawText = extractedItems.map(\.text).joined(separator: " ")
        self.processedDate = processedDate
    }

    /// Case-insensitive search: matches raw text content or entity type names.
    func matches(query: String) -> Bool {
        guard !query.isEmpty else { return true }
        let lower = query.lowercased()
        if rawText.lowercased().contains(lower) { return true }
        let entityNames = Set(extractedItems.map { $0.entityType.displayName.lowercased() })
        if entityNames.contains(where: { $0.contains(lower) }) { return true }
        return false
    }
}
