// SweepOverlay.swift
// Extracta — Sweep gesture interaction layer
// Preserved from original Phase 3 implementation with dark mode
// and accessibility improvements.

import SwiftUI

struct SweepOverlay: View {

    // ── Inputs ───────────────────────────────────────────────────────────
    let canvasSize: CGSize
    @ObservedObject var viewModel: CanvasViewModel

    // ── Internal state ───────────────────────────────────────────────────
    @State private var dragStartX: CGFloat  = 0
    @State private var hasBegunDrag: Bool   = false
    @State private var showCompletionFlash: Bool = false

    @Environment(\.colorScheme) private var colorScheme

    // ── Derived geometry ─────────────────────────────────────────────────
    private var fillWidth:  CGFloat { canvasSize.width * viewModel.sweepProgress }
    private var lineOffset: CGFloat { fillWidth - 1 }

    // ── Dark-mode-adaptive fill opacities ────────────────────────────────
    // After completion, the fill fades so bounding box overlays are visible.
    private var fillOpacityLeading: Double {
        viewModel.didCompleteSweep
            ? 0.05
            : (colorScheme == .dark ? 0.35 : 0.26)
    }
    private var fillOpacityTrailing: Double {
        viewModel.didCompleteSweep
            ? 0.02
            : (colorScheme == .dark ? 0.18 : 0.10)
    }

    // ── Body ─────────────────────────────────────────────────────────────

    var body: some View {
        ZStack(alignment: .leading) {
            sweepFill

            // Sweep line + progress — hidden after completion so overlays
            // are the primary visual.
            if (viewModel.isSweeping || viewModel.sweepProgress > 0)
                && !viewModel.didCompleteSweep {
                sweepLine
                progressLabel
            }

            // Hint label — idle state only
            if !viewModel.isSweeping
                && viewModel.sweepProgress == 0
                && !viewModel.didCompleteSweep {
                hintLabel
            }

            if showCompletionFlash {
                Color.white.opacity(0.18)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .contentShape(Rectangle())
        .gesture(sweepGesture)
        .onChange(of: viewModel.didCompleteSweep) {
            if viewModel.didCompleteSweep { handleCompletion() }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityAddTraits(.allowsDirectInteraction)
    }

    // ── Accessibility ────────────────────────────────────────────────────

    private var accessibilityDescription: String {
        if viewModel.didCompleteSweep {
            return "Sweep complete. Text extracted."
        } else if viewModel.isSweeping {
            return "Sweeping. \(Int(viewModel.sweepProgress * 100)) percent."
        } else {
            return "Sweep across the image to extract text."
        }
    }

    // ── Visual components (preserved from original) ─────────────────────

    private var sweepFill: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(fillOpacityLeading),
                Color.blue.opacity(fillOpacityTrailing)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: max(fillWidth, 0), height: canvasSize.height)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(
            viewModel.isSweeping
                ? .interactiveSpring(response: 0.20, dampingFraction: 0.80)
                : .spring(response: 0.32, dampingFraction: 0.72),
            value: viewModel.sweepProgress
        )
    }

    private var sweepLine: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.0),
                Color.blue.opacity(1.0),
                Color.blue.opacity(0.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: 2.5, height: canvasSize.height)
        .shadow(color: .blue.opacity(0.6), radius: 8, x: 0, y: 0)
        .offset(x: max(lineOffset, 0))
        .animation(
            viewModel.isSweeping
                ? .interactiveSpring(response: 0.20, dampingFraction: 0.80)
                : .spring(response: 0.32, dampingFraction: 0.72),
            value: viewModel.sweepProgress
        )
    }

    private var progressLabel: some View {
        let pct = Int(viewModel.sweepProgress * 100)
        let labelWidth: CGFloat = 44
        let clampedX = min(max(fillWidth - labelWidth / 2, 0),
                          canvasSize.width - labelWidth)
        return Text("\(pct)%")
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .foregroundStyle(.blue)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(.ultraThinMaterial, in: Capsule())
            .frame(width: labelWidth)
            .offset(x: clampedX, y: -(canvasSize.height / 2 - 20))
            .animation(
                .interactiveSpring(response: 0.20, dampingFraction: 0.80),
                value: viewModel.sweepProgress
            )
    }

    private var hintLabel: some View {
        HStack(spacing: 6) {
            Image(systemName: "hand.draw")
                .font(.system(size: 13, weight: .medium))
            Text("Sweep to extract")
                .font(.system(size: 13, weight: .medium))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    // ── Gesture (preserved from original) ────────────────────────────────

    private var sweepGesture: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .onChanged { value in
                if !hasBegunDrag {
                    dragStartX   = value.startLocation.x
                    hasBegunDrag = true
                    viewModel.beginSweep()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                let travel   = value.location.x - dragStartX
                let progress = travel / canvasSize.width
                viewModel.updateSweep(progress: progress)
            }
            .onEnded { _ in
                hasBegunDrag = false
                viewModel.endSweep()
            }
    }

    // ── Completion (preserved from original) ─────────────────────────────

    private func handleCompletion() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation(.easeIn(duration: 0.12)) { showCompletionFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.easeOut(duration: 0.20)) { showCompletionFlash = false }
        }
    }
}
