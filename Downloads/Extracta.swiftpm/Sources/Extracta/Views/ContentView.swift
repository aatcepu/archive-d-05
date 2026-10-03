// ContentView.swift
// Extracta — Root view with photo picker, sweep canvas, and library access
// Toolbar layout preserved from original with PhotosPicker and library additions.

import SwiftUI
import PhotosUI

struct ContentView: View {

    @StateObject private var canvasViewModel = CanvasViewModel()
    @StateObject private var library = SearchableLibrary()

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showLibrary = false

    // ── Body ─────────────────────────────────────────────────────────────

    var body: some View {
        NavigationStack {
            ScreenshotCanvas(viewModel: canvasViewModel)
                .navigationTitle("Extracta")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarContent }
                .onChange(of: selectedPhotoItem) {
                    loadSelectedPhoto()
                }
                .onChange(of: canvasViewModel.isExtracting) {
                    // Index the screenshot once extraction finishes
                    if !canvasViewModel.isExtracting
                        && canvasViewModel.didCompleteSweep
                        && !canvasViewModel.extractedItems.isEmpty {
                        indexCurrentScreenshot()
                    }
                }
                .sheet(isPresented: $showLibrary) {
                    librarySheet
                }
                .overlay(alignment: .bottom) {
                    if canvasViewModel.showCopiedToast {
                        copiedToast
                    }
                }
        }
    }

    // ── Toolbar ──────────────────────────────────────────────────────────

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images
            ) {
                Image(systemName: "photo.on.rectangle")
            }
            .accessibilityLabel("Select a photo")
        }

        ToolbarItemGroup(placement: .topBarTrailing) {
            if !library.indexedScreenshots.isEmpty {
                Button {
                    showLibrary = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search visual memory")
            }

            Button {
                canvasViewModel.resetSweep()
            } label: {
                Image(systemName:
                    canvasViewModel.sweepProgress > 0
                        ? "arrow.counterclockwise"
                        : "wand.and.stars"
                )
                .foregroundStyle(
                    canvasViewModel.sweepProgress > 0
                        ? Color.blue
                        : Color.primary
                )
                .animation(.easeInOut(duration: 0.2),
                           value: canvasViewModel.sweepProgress)
            }
            .accessibilityLabel(
                canvasViewModel.sweepProgress > 0 ? "Reset" : "Extracta"
            )
        }
    }

    // ── Library sheet ────────────────────────────────────────────────────

    private var librarySheet: some View {
        NavigationStack {
            LibraryView(
                viewModel: LibraryViewModel(library: library)
            ) { screenshot in
                if let image = UIImage(data: screenshot.imageData) {
                    canvasViewModel.setImage(image)
                    showLibrary = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { showLibrary = false }
                }
            }
        }
    }

    // ── Copied toast ─────────────────────────────────────────────────────

    private var copiedToast: some View {
        Text("Copied to clipboard")
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(.bottom, 32)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // ── Actions ──────────────────────────────────────────────────────────

    private func loadSelectedPhoto() {
        Task {
            if let item = selectedPhotoItem,
               let image = await PhotoLibraryService.loadImage(from: item) {
                canvasViewModel.setImage(image)
            }
        }
    }

    private func indexCurrentScreenshot() {
        guard let image = canvasViewModel.currentImage,
              let data = ImageProcessor.thumbnail(from: image)
        else { return }

        let raw = canvasViewModel.extractedItems.map(\.text).joined(separator: " ")
        if let top = library.indexedScreenshots.first, top.rawText == raw {
            return
        }

        let screenshot = IndexedScreenshot(
            imageData: data,
            extractedItems: canvasViewModel.extractedItems
        )
        library.index(screenshot: screenshot)
    }
}
