//
//  HistoryListView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct HistoryListView: View {
    private struct Entry: Identifiable {
        let id = UUID()
        let date: Date
        let title: String
        let subtitle: String
        let preview: String
        let moodTag: String
        let timeString: String
    }

    private var todayEntries: [Entry] = [
        Entry(date: .now, title: "Feeling very productive today", subtitle: "HAPPY", preview: "Finally finished the project milestone.", moodTag: "HAPPY", timeString: "08:15 AM"),
        Entry(date: .now.addingTimeInterval(-3600 * 2), title: "A bit overwhelmed", subtitle: "ANXIOUS", preview: "Coffee didn't help as much as I thought…", moodTag: "ANXIOUS", timeString: "11:30 AM")
    ]

    private var earlierEntries: [Entry] = [
        Entry(date: .now.addingTimeInterval(-3600*24*2), title: "Quiet morning meditation", subtitle: "CALM", preview: "New meditation app helped.", moodTag: "CALM", timeString: "07:40 AM"),
        Entry(date: .now.addingTimeInterval(-3600*24*3), title: "New ideas for the home", subtitle: "INSPIRED", preview: "Sketched some layouts in the main hallway.", moodTag: "INSPIRED", timeString: "05:45 PM")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionHeader("Today")
                ForEach(todayEntries) { entry in
                    entryRow(entry)
                }

                sectionHeader("Earlier this week")
                ForEach(earlierEntries) { entry in
                    entryRow(entry)
                }
            }
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundColor(Color.theme.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }

    private func entryRow(_ entry: Entry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(entry.subtitle.capitalized)
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.theme.accent.opacity(0.6))
                            )
                        Spacer()
                        Text(entry.timeString)
                            .font(.caption.weight(.medium))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    Text(entry.title)
                        .font(.headline.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                    Text(entry.preview)
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                Button("View Entry") {}
                    .font(.callout.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
            }
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    ZStack { Color.theme.background.ignoresSafeArea() }
    HistoryListView()
        .padding()
}
