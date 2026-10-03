// SearchableLibrary.swift
// Extracta — In-memory index of processed screenshots

import Foundation

/// Maintains an in-memory collection of indexed screenshots and provides
/// local full-text search. Designed for session-length persistence — no
/// disk I/O, no network. Sufficient for a 3-minute demo flow.
@MainActor
final class SearchableLibrary: ObservableObject {

    @Published private(set) var indexedScreenshots: [IndexedScreenshot] = []

    /// Add a processed screenshot to the front of the index.
    func index(screenshot: IndexedScreenshot) {
        indexedScreenshots.insert(screenshot, at: 0)
    }

    /// Search indexed screenshots by text content or entity type name.
    /// Returns all screenshots if the query is empty.
    func search(query: String) -> [IndexedScreenshot] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return indexedScreenshots }
        return indexedScreenshots.filter { $0.matches(query: trimmed) }
    }
}
