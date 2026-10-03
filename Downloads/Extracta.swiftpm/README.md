# Extracta

A privacy-first visual memory tool for students.

## What It Does

Extracta turns screenshots into searchable, actionable information — entirely
on-device. Sweep across a screenshot, and Vision framework reads every word,
detects phone numbers, dates, addresses, emails, and links, and surfaces them
as one-tap actions.

## The Problem

Students continuously screenshot lecture slides, formulas, assignment
instructions, event posters, deadlines, and contact information. The problem
isn't storing this information — it's **finding and using it later**. Extracta
addresses this by turning static screenshots into searchable, actionable
visual memory while preserving privacy through on-device processing.

## How to Open

1. Rename this folder to `Extracta.swiftpm` if it isn't already.
2. Open in **Swift Playgrounds 4.6+** or **Xcode 26+**.

## Privacy

- All processing happens on-device using Apple's Vision framework.
- No network connection required — works fully in Airplane Mode.
- No data leaves the device.
- No analytics, tracking, or telemetry.
- No account or login required.

## Architecture

Clean MVVM with service layer:

| Layer | Contents |
|-------|----------|
| **Models** | `EntityType`, `ExtractedItem`, `IndexedScreenshot` |
| **ViewModels** | `CanvasViewModel`, `LibraryViewModel` |
| **Views** | `ContentView`, `ScreenshotCanvas`, `SweepOverlay`, `BoundingBoxOverlay`, `ActionChipBar`, `LibraryView` |
| **Services** | `OCRService`, `EntityDetectionService`, `PhotoLibraryService`, `SearchableLibrary` |
| **Utilities** | `ImageProcessor`, `ClipboardService` |

## Frameworks Used

All Apple first-party — no third-party dependencies:

- **SwiftUI** — UI framework
- **Vision** — on-device text recognition (VNRecognizeTextRequest)
- **Foundation** — entity detection (NSDataDetector)
- **PhotosUI** — out-of-process photo picker
- **UIKit** — haptic feedback, image rendering

## Third-Party Code / Assets

**None.** This project contains no third-party code, libraries, or assets.
All code is original work. All frameworks are Apple first-party.
