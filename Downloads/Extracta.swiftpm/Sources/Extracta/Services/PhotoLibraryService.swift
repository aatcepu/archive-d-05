// PhotoLibraryService.swift
// Extracta — Photo loading from PhotosPicker

import SwiftUI
import PhotosUI
import UIKit

/// Handles loading images from PhotosPickerItem selections.
/// Uses the out-of-process PhotosPicker which does NOT require
/// NSPhotoLibraryUsageDescription — the system handles permissions.
enum PhotoLibraryService {

    /// Load a UIImage from a PhotosPickerItem.
    @MainActor
    static func loadImage(from item: PhotosPickerItem) async -> UIImage? {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data)
        else { return nil }
        return image
    }
}

