//
//  AddNewLogFlowView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct AddNewLogFlowView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMood: Int? = nil
    @State private var intensity: Double = 7
    @State private var goToJournal: Bool = false

    private struct Mood: Identifiable { let id = UUID(); let icon: String; let title: String }
    private let moods: [Mood] = [
        .init(icon: "🙂", title: "Happy"),
        .init(icon: "😌", title: "Calm"),
        .init(icon: "⚡️", title: "Energetic"),
        .init(icon: "😣", title: "Stressed"),
        .init(icon: "😢", title: "Sad"),
        .init(icon: "😴", title: "Tired")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    progressHeader
                    title
                    moodGrid
                    intensitySection
                    Spacer(minLength: 12)
                    primaryButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .navigationDestination(isPresented: $goToJournal) {
                    AddJournalEntryView(title: defaultTitle(), bodyText: defaultBody(), date: Date(), moodTitle: selectedMoodTitle())
                }
            }
            .toolbar { toolbarContent }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header & Title

    private var progressHeader: some View {
        HStack {
            Text("STEP 1 OF 2")
                .font(.caption2.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
            Text("50% Complete")
                .font(.caption2.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
        }
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.08)).frame(height: 4)
                Capsule().fill(Color.theme.accent).frame(width: UIScreen.main.bounds.width * 0.5 - 32, height: 4)
            }
            .padding(.top, 18)
        }
    }

    private var title: some View {
        VStack(spacing: 6) {
            Text("How are you feeling right now?")
                .font(.title2.weight(.bold))
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Select the mood that best describes your state")
                .font(.footnote.weight(.medium))
                .foregroundColor(Color.theme.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Mood Grid

    private var moodGrid: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 12) {
            ForEach(Array(moods.enumerated()), id: \.offset) { index, mood in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { selectedMood = index }
                } label: {
                    HStack(spacing: 10) {
                        Text(mood.icon).font(.title2)
                        Text(mood.title)
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.theme.accent)
                        Spacer()
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(selectedMood == index ? Color.theme.accent.opacity(0.25) : Color.theme.accent.opacity(0.10))
                            if selectedMood == index {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.theme.accent, lineWidth: 2)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Intensity

    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Intensity")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                    Text("How strong is this feeling?")
                        .font(.caption.weight(.medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                Spacer()
                Text("\(Int(intensity))")
                    .font(.headline.weight(.bold))
                    .foregroundColor(Color.theme.accent)
            }
            Slider(value: $intensity, in: 1...10, step: 1)
                .tint(Color.theme.accent)
            HStack {
                Text("Mellow")
                Spacer()
                Text("Moderate")
                Spacer()
                Text("Intense")
            }
            .font(.caption.weight(.semibold))
            .foregroundColor(Color.theme.secondaryText)
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
    }

    // MARK: - Primary Button

    private var primaryButton: some View {
        Button {
            goToJournal = true
        } label: {
            HStack {
                Text("Continue to Journal")
                    .font(.body.weight(.semibold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.body.weight(.semibold))
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.theme.accent)
                    .shadow(color: Color.theme.accent.opacity(0.5), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
        .disabled(selectedMood == nil)
        .opacity(selectedMood == nil ? 0.6 : 1)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
            }
            .tint(Color.theme.accent)
        }
        ToolbarItem(placement: .principal) {
            Text("Add New Log")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private func selectedMoodTitle() -> String {
        if let idx = selectedMood {
            return moods[idx].title
        } else {
            return ""
        }
    }
    
    private func defaultTitle() -> String {
        return "The morning quiet"
    }
    
    private func defaultBody() -> String {
        return "It's finally a peaceful morning. I can hear the distant sound of the city waking up while the coffee brews.\n\nThinking about the goals for this week and how to stay mindful during the busy afternoons. There is something special about these early hours..."
    }
}

#Preview {
    AddNewLogFlowView()
}
