//
//  AddJournalEntryView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct AddJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss

    @State var title: String
    @State var bodyText: String
    let date: Date

    var moodTitle: String

    var body: some View {
        VStack(spacing: 0) {
            editor
            footer
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
    }

    private var editor: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Mood pill + tags row
                HStack(spacing: 8) {
                    Label(moodTitle, systemImage: "face.smiling")
                        .font(.callout.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.theme.accent.opacity(0.15)))
                        .foregroundColor(Color.theme.accent)
                    Spacer()
                    Button(action: {}) { Image(systemName: "plus.circle") }
                        .tint(Color.theme.accent)
                }

                // Title
                TextField("The morning quiet", text: $title)
                    .font(.title2.weight(.bold))
                    .foregroundColor(Color.theme.accent)
                    .padding(.vertical, 4)

                // Date line
                Text(formatted(date))
                    .font(.footnote.weight(.medium))
                    .foregroundColor(Color.theme.secondaryText)

                // Body
                TextEditor(text: $bodyText)
                    .frame(minHeight: 240)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
            }
            .padding(16)
        }
    }

    private var footer: some View {
        HStack(spacing: 16) {
            Image(systemName: "lock.fill").font(.footnote)
            Text("End‑to‑end encrypted")
                .font(.footnote.weight(.medium))
            Spacer()
            Image(systemName: "mic.fill")
            Image(systemName: "photo.on.rectangle")
            Image(systemName: "tag")
            Text("\(wordCount) words")
                .font(.footnote)
        }
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var wordCount: Int {
        let words = bodyText.split { !$0.isLetter && !$0.isNumber }
        return words.count
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Step 2 of 2")
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
        }
        ToolbarItem(placement: .principal) {
            Text("Add New Log")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button("Done") { dismiss() }
                .font(.body.weight(.semibold))
                .tint(Color.theme.accent)
        }
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy • h:mm a"
        return f.string(from: date)
    }
}

#Preview {
    NavigationStack {
        AddJournalEntryView(title: "The morning quiet", bodyText: "It's finally a peaceful morning...", date: Date(), moodTitle: "Feeling Calm")
    }
}
