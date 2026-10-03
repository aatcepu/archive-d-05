// ClipboardService.swift
// Extracta — Clipboard utility

import UIKit

/// Isolates clipboard operations from Views.
enum ClipboardService {
    @MainActor
    static func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
