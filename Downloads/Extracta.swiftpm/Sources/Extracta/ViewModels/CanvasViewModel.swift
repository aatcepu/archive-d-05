// CanvasViewModel.swift
// Extracta — Sweep gesture state + OCR extraction coordination
// Sweep state machine preserved from original Phase 3 implementation.

import SwiftUI
import Combine

@MainActor
final class CanvasViewModel: ObservableObject {

    // ── Published state (sweep — preserved from original) ───────────────

    @Published private(set) var sweepProgress: Double = 0.0
    @Published private(set) var isSweeping: Bool = false
    @Published private(set) var didCompleteSweep: Bool = false

    // ── Published state (image & extraction) ────────────────────────────

    @Published var currentImage: UIImage?
    @Published private(set) var extractedItems: [ExtractedItem] = []
    @Published private(set) var isExtracting: Bool = false
    @Published var selectedItem: ExtractedItem?
    @Published private(set) var showCopiedToast: Bool = false

    // ── Configuration (preserved from original) ─────────────────────────

    private let completionThreshold: Double = 0.85
    private var extractionTask: Task<Void, Never>?

    // ── Sweep lifecycle (preserved from original) ───────────────────────

    func beginSweep() {
        guard !isSweeping else { return }
        isSweeping = true
        didCompleteSweep = false
        sweepProgress = 0.0
    }

    func updateSweep(progress: Double) {
        sweepProgress = progress.clamped(to: 0...1)
    }

    func endSweep() {
        isSweeping = false

        if sweepProgress >= completionThreshold {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.72)) {
                sweepProgress = 1.0
            }
            // FIX (preserved): set Bool flag outside withAnimation — animating
            // a Bool is a no-op and triggers unnecessary SwiftUI diffs.
            didCompleteSweep = true

            // Phase 4: trigger OCR extraction
            extractionTask?.cancel()
            extractionTask = Task { await performExtraction() }
        } else {
            withAnimation(.easeOut(duration: 0.28)) {
                sweepProgress = 0.0
            }
        }
    }

    func resetSweep() {
        extractionTask?.cancel()
        // FIX (preserved): didCompleteSweep outside animation block
        didCompleteSweep = false
        extractedItems = []
        selectedItem = nil
        withAnimation(.easeOut(duration: 0.22)) {
            sweepProgress = 0.0
            isSweeping    = false
        }
    }

    // ── Image management ─────────────────────────────────────────────────

    func setImage(_ image: UIImage) {
        currentImage = image
        resetSweep()
    }

    // ── OCR extraction ──────────────────────────────────────────────────

    private func performExtraction() async {
        guard let cgImage = currentImage?.cgImage else { return }

        isExtracting = true
        defer { isExtracting = false }

        let observations = await OCRService.recognize(from: cgImage)

        // Bail out if the task was cancelled (user started a new sweep)
        guard !Task.isCancelled else { return }

        let items = EntityDetectionService.process(observations: observations)

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            extractedItems = items
        }
    }

    // ── Actions ──────────────────────────────────────────────────────────

    func copyText(_ text: String) {
        ClipboardService.copy(text)
        withAnimation(.easeInOut(duration: 0.2)) {
            showCopiedToast = true
        }
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation(.easeOut(duration: 0.3)) {
                showCopiedToast = false
            }
        }
    }

    func performAction(for item: ExtractedItem) {
        switch item.entityType {
        case .phoneNumber:
            let digits = item.text.filter { $0.isNumber || $0 == "+" }
            if let url = URL(string: "tel:\(digits)") {
                UIApplication.shared.open(url)
            }
            copyText(item.text)

        case .url:
            if let url = URL(string: item.text) {
                UIApplication.shared.open(url)
            } else {
                copyText(item.text)
            }

        case .email:
            if let url = URL(string: "mailto:\(item.text)") {
                UIApplication.shared.open(url)
            }
            copyText(item.text)

        case .address:
            let encoded = item.text.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? ""
            if let url = URL(string: "maps://?q=\(encoded)") {
                UIApplication.shared.open(url)
            }
            copyText(item.text)

        case .date, .plain:
            copyText(item.text)
        }
    }
}

// ── Clamped helper (preserved from original) ─────────────────────────────────

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
