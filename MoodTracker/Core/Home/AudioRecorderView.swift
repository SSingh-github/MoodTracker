//
//  AudioRecorderView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI
import AVFoundation

struct AudioRecorderView: View {
    enum RecordingState { case idle, recording, paused }

    @Environment(\.dismiss) private var dismiss

    @State private var state: RecordingState = .idle
    @State private var seconds: Int = 0
    @State private var timer: Timer? = nil
    @State private var pulse: Bool = false
    @State private var wavePhase: CGFloat = 0
    @State private var waveTimer: Timer?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                VStack(spacing: 24) {
                    header
                    micButton
                    durationRow
                    waveform
                    transcriptHint
                    primaryActions
                    secondaryActions
                }
                .padding(16)
            }
            .navigationTitle("Recording Entry…")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent() }
            .onAppear { configureAudioSession() }
            .onDisappear { stopTimers() }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.fill").font(.footnote)
            Text("End‑to‑end encrypted")
                .font(.footnote.weight(.medium))
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
        }
    }

    // MARK: - Mic Button with radial animation
    private var micButton: some View {
        Button(action: toggleRecording) {
            ZStack {
                // Pulsing radial rings
                ZStack {
                    Circle()
                        .fill(Color.theme.accent.opacity(0.15))
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulse && state == .recording ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulse && state == .recording)
                    Circle()
                        .stroke(Color.theme.accent.opacity(0.35), lineWidth: 2)
                        .frame(width: 220, height: 220)
                        .scaleEffect(pulse && state == .recording ? 1.1 : 0.95)
                        .opacity(pulse && state == .recording ? 0.7 : 0.3)
                        .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: pulse && state == .recording)
                }

                // Mic pill
                Circle()
                    .fill(Color.theme.accent)
                    .frame(width: 88, height: 88)
                    .shadow(color: Color.theme.accent.opacity(0.5), radius: 12, x: 0, y: 6)
                Image(systemName: state == .recording ? "stop.fill" : "mic.fill")
                    .foregroundColor(.white)
                    .font(.title2.weight(.bold))
            }
        }
        .buttonStyle(.plain)
        .onAppear { pulse = true }
    }

    // MARK: - Duration
    private var durationRow: some View {
        HStack(spacing: 24) {
            timeBlock(value: seconds / 60, label: "MIN")
            timeBlock(value: seconds % 60, label: "SEC")
        }
        .padding(.top, 8)
    }

    private func timeBlock(value: Int, label: String) -> some View {
        VStack(spacing: 6) {
            Text(String(format: "%02d", value))
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.caption.weight(.heavy))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(width: 96, height: 72)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
    }

    // MARK: - Waveform
    private var waveform: some View {
        WaveView(phase: wavePhase)
            .frame(height: 60)
            .padding(.horizontal, 24)
            .opacity(state == .recording ? 1 : 0.4)
            .animation(.easeInOut(duration: 0.2), value: state)
            .onChange(of: state) { _, newValue in
                if newValue == .recording { startWave() } else { stopWave() }
            }
    }

    // MARK: - Transcript hint
    private var transcriptHint: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\"I've been feeling a bit more energetic today after my morning walk...\"")
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryText)
                .padding(12)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
        }
        .padding(.top, 8)
    }

    // MARK: - Primary Actions
    private var primaryActions: some View {
        VStack(spacing: 12) {
            Button(action: stopAndSave) {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("Stop & Save Entry")
                        .font(.body.weight(.semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.theme.accent)
                        .shadow(color: Color.theme.accent.opacity(0.5), radius: 12, x: 0, y: 6)
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var secondaryActions: some View {
        VStack(spacing: 8) {
            Button("Go Back") { dismiss() }
                .font(.callout.weight(.semibold))
                .foregroundColor(Color.theme.accent)
        }
        .padding(.top, 4)
    }

    // MARK: - Toolbar
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
            }
            .accessibilityLabel("Close")
        }
        return ToolbarItemGroup(placement: .topBarTrailing) {
            if state == .recording {
                Button(action: { toggleRecording() }) {
                    Image(systemName: "pause.fill")
                }
                .accessibilityLabel("Pause Recording")
            } else if state == .paused {
                Button(action: { toggleRecording() }) {
                    Image(systemName: "play.fill")
                }
                .accessibilityLabel("Resume Recording")
            }
        }
    }

    // MARK: - Logic
    private func configureAudioSession() {
        // Placeholder for audio session config
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
        } catch { /* handle error */ }
    }

    private func toggleRecording() {
        switch state {
        case .idle, .paused:
            state = .recording
            startTimer()
            startWave()
        case .recording:
            state = .paused
            stopTimer()
            stopWave()
        }
    }

    private func stopAndSave() {
        stopTimer()
        stopWave()
        state = .idle
        // Hook save logic here
        dismiss()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            seconds += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func stopTimers() {
        stopTimer()
        stopWave()
    }

    private func startWave() {
        waveTimer?.invalidate()
        withAnimation(.linear(duration: 0.2)) { wavePhase = 0 }
        waveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            if state != .recording {
                t.invalidate()
                waveTimer = nil
                return
            }
            wavePhase += 0.15
        }
    }

    private func stopWave() {
        waveTimer?.invalidate()
        waveTimer = nil
    }
}

// MARK: - Wave View
private struct WaveView: View {
    let phase: CGFloat
    private let barCount = 28

    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .center, spacing: 4) {
                ForEach(0..<barCount, id: \.self) { i in
                    let progress = CGFloat(i) / CGFloat(barCount)
                    let height = barHeight(progress: progress, phase: phase, available: geo.size.height)
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(Color.theme.accent)
                        .frame(width: 4, height: height)
                        .animation(.easeInOut(duration: 0.2), value: phase)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func barHeight(progress: CGFloat, phase: CGFloat, available: CGFloat) -> CGFloat {
        let base: CGFloat = 8
        let amp: CGFloat = available * 0.4
        let value = abs(sin((progress * 2 * .pi) + phase))
        return max(base, value * amp + base)
    }
}

#Preview {
    AudioRecorderView()
}
