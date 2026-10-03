// LibraryViewModel.swift
// Extracta — Search and browse the visual memory index

import SwiftUI

@MainActor
final class LibraryViewModel: ObservableObject {

    @Published var searchQuery: String = ""

    let library: SearchableLibrary

    init(library: SearchableLibrary) {
        self.library = library
    }

    /// Screenshots filtered by the current search query.
    var displayedScreenshots: [IndexedScreenshot] {
        library.search(query: searchQuery)
    }

    /// True when the library has no indexed screenshots at all.
    var isEmpty: Bool {
        library.indexedScreenshots.isEmpty
    }
}
