//
//  HistoryCalendarView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct HistoryCalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()

    // Sample dots for moods per date
    private let moodDots: [Int: Color] = [
        1: .blue, 3: .green, 5: .yellow, 8: .orange, 12: .purple, 18: .red, 22: .green, 25: .blue
    ]

    var body: some View {
        VStack(spacing: 16) {
            monthHeader
            calendarGrid
            legend
            entriesForSelectedDate
        }
        .padding(.vertical, 8)
    }

    private var monthHeader: some View {
        HStack {
            Button { withAnimation { currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth } } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(monthTitle(for: currentMonth))
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)
            Spacer()
            Button { withAnimation { currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth } } label: {
                Image(systemName: "chevron.right")
            }
        }
        .tint(Color.theme.accent)
        .padding(12)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
    }

    private var calendarGrid: some View {
        let days = makeDays(for: currentMonth)
        return VStack(spacing: 8) {
            // Weekday headers
            HStack {
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { d in
                    Text(d)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 4)

            // Weeks
            ForEach(0..<days.count/7, id: \.self) { week in
                HStack(spacing: 8) {
                    ForEach(0..<7, id: \.self) { offset in
                        let index = week * 7 + offset
                        let item = days[index]
                        dayCell(item)
                    }
                }
            }
        }
        .padding(12)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
    }

    private func dayCell(_ item: DayItem) -> some View {
        let isSelected = Calendar.current.isDate(item.date, inSameDayAs: selectedDate)
        let isToday = Calendar.current.isDateInToday(item.date)
        return Button {
            guard item.isCurrentMonth else { return }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedDate = item.date
            }
        } label: {
            VStack(spacing: 6) {
                Text("\(Calendar.current.component(.day, from: item.date))")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(item.isCurrentMonth ? Color.theme.accent : Color.theme.secondaryText.opacity(0.6))
                    .frame(maxWidth: .infinity)
                Circle()
                    .fill(moodDots[Calendar.current.component(.day, from: item.date)] ?? .clear)
                    .frame(width: 6, height: 6)
                    .opacity(item.isCurrentMonth ? 1 : 0)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.theme.accent.opacity(0.15))
                    }
                    if isToday {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.theme.accent, lineWidth: 1)
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .disabled(!item.isCurrentMonth)
    }

    private var legend: some View {
        HStack(spacing: 16) {
            legendItem(color: .green, text: "Calm")
            legendItem(color: .yellow, text: "Happy")
            legendItem(color: .orange, text: "Anxious")
            legendItem(color: .blue, text: "Sad")
            legendItem(color: .purple, text: "Excited")
            legendItem(color: .red, text: "Angry")
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
        }
    }

    private var entriesForSelectedDate: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(formattedDate(selectedDate) + " Entries")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)
            ForEach(0..<3, id: \.self) { idx in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sample entry #\(idx + 1)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                    Text("This is a placeholder for the entry preview text.")
                        .font(.footnote)
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                }
                .padding(12)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
            }
        }
    }

    // MARK: - Calendar helpers

    private struct DayItem { let date: Date; let isCurrentMonth: Bool }

    private func makeDays(for month: Date) -> [DayItem] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) // 1..7 Sun..Sat
        let leading = (firstWeekday - calendar.firstWeekday + 7) % 7

        var days: [DayItem] = []
        // Leading days
        if leading > 0 {
            for i in 0..<leading {
                let date = calendar.date(byAdding: .day, value: i - leading, to: startOfMonth)!
                days.append(DayItem(date: date, isCurrentMonth: false))
            }
        }
        // Current month days
        for day in range {
            let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
            days.append(DayItem(date: date, isCurrentMonth: true))
        }
        // Trailing to fill weeks
        while days.count % 7 != 0 {
            let lastDate = days.last!.date
            let next = calendar.date(byAdding: .day, value: 1, to: lastDate)!
            days.append(DayItem(date: next, isCurrentMonth: false))
        }
        return days
    }

    private func monthTitle(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f.string(from: date)
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM d"
        return f.string(from: date)
    }
}

#Preview {
    ZStack { Color.theme.background.ignoresSafeArea() }
    HistoryCalendarView()
        .padding()
}
