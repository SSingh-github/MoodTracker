//
//  LogMoodSheet.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct LogMoodSheet: View {
    @Environment(\.dismiss) private var dismiss

    // Bindings/inputs
    @Binding var selectedMoodIndex: Int?

    // Local state
    @State private var note: String = ""

    private let moods: [(emoji: String, label: String)] = [
        ("😟", "Distressed"),
        ("😞", "Down"),
        ("🧑🏻", "Neutral"),
        ("😊", "Happy"),
        ("😁", "Elated")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    moodSelector
                    noteSection
                    e2eFooter
                    saveButton
                }
                .padding(20)
            }
            .background(Color.theme.background.ignoresSafeArea())
            .toolbar { toolbarContent }
        }
        .presentationDetents([.medium, .large])
        .presentationCornerRadius(28)
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 6) {
            Text("How are you feeling right now?")
                .font(.title2.weight(.semibold))
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.center)
            Text("Take a moment to check in with yourself")
                .font(.footnote.weight(.medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var moodSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(moods.indices, id: \.self) { index in
                    let mood = moods[index]
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedMoodIndex = index
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Text(mood.emoji)
                                .font(.system(size: 44))
                            Text(mood.label)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(Color.theme.accent)
                        }
                        .frame(width: 96, height: 120)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .fill(LinearGradient(
                                        colors: selectedMoodIndex == index
                                            ? [Color.theme.accent.opacity(0.30), Color.theme.accent.opacity(0.12)]
                                            : [Color.theme.accent.opacity(0.12), Color.theme.accent.opacity(0.06)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                if selectedMoodIndex == index {
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .stroke(Color.theme.accent, lineWidth: 2)
                                        .shadow(color: Color.theme.accent.opacity(0.5), radius: 8, x: 0, y: 2)
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Select mood: \(mood.label)")
                    .accessibilityAddTraits(selectedMoodIndex == index ? .isSelected : [])
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .foregroundStyle(Color.theme.accent)
                Text("Add a quick note… (optional)")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
            }
            TextEditor(text: $note)
                .frame(minHeight: 140)
                .padding(12)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .overlay(
                    Group {
                        if note.isEmpty {
                            Text("What's making you feel this way?")
                                .foregroundColor(Color.theme.secondaryText)
                                .font(.callout)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                )
        }
    }

    private var e2eFooter: some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.fill")
                .font(.footnote)
                .foregroundStyle(Color.theme.secondaryText)
            Text("End‑to‑end encrypted")
                .font(.footnote.weight(.medium))
                .foregroundColor(Color.theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }

    private var saveButton: some View {
        Button {
            // Here you'd persist the mood + note.
            // For now, simply dismiss the sheet.
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Text("Save Mood")
                    .font(.headline.weight(.semibold))
                Image(systemName: "checkmark.circle.fill")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.theme.accent)
                    .shadow(color: Color.theme.accent.opacity(0.45), radius: 10, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
        .disabled(selectedMoodIndex == nil)
        .opacity(selectedMoodIndex == nil ? 0.6 : 1.0)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close") { dismiss() }
                .tint(Color.theme.accent)
        }
    }
}

#Preview {
    ZStack { Color.black.ignoresSafeArea() }
    LogMoodSheet(selectedMoodIndex: .constant(3))
}
