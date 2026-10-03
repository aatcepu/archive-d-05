// EntityType.swift
// Extracta — Semantic entity classification for extracted text

import SwiftUI

/// Classifies a text fragment detected by Vision OCR + NSDataDetector.
enum EntityType: String, CaseIterable, Sendable, Hashable {
    case plain
    case phoneNumber
    case date
    case url
    case address
    case email

    /// Human-readable label shown in chips and accessibility.
    var displayName: String {
        switch self {
        case .plain:       "Text"
        case .phoneNumber: "Phone"
        case .date:        "Date"
        case .url:         "Link"
        case .address:     "Address"
        case .email:       "Email"
        }
    }

    /// SF Symbol for the entity type.
    var icon: String {
        switch self {
        case .plain:       "doc.text"
        case .phoneNumber: "phone"
        case .date:        "calendar"
        case .url:         "link"
        case .address:     "map"
        case .email:       "envelope"
        }
    }

    /// Colour used for bounding box overlay and action chip.
    var color: Color {
        switch self {
        case .plain:       .secondary
        case .phoneNumber: .green
        case .date:        .blue
        case .url:         .orange
        case .address:     .purple
        case .email:       .cyan
        }
    }
}
