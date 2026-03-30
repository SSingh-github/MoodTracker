//
//  StreaksProgressView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct StreaksProgressView: View {
    // Placeholder data you can later bind to your model
    let currentStreakDays: Int
    let nextMilestoneDays: Int
    let completedMilestones: [Milestone]
    let month: Date
    let checkedDays: Set<Int>

    init(
        currentStreakDays: Int = 15,
        nextMilestoneDays: Int = 20,
        completedMilestones: [Milestone] = [
            .init(icon: "sparkles", title: "7-Day Spark", color: .blue),
            .init(icon: "moon.zzz.fill", title: "Monthly Calm", color: .indigo)
        ],
        month: Date = .now,
        checkedDays: Set<Int> = [1,2,3,4,5,6,7,8,10,11,12,13,14,15]
    ) {
        self.currentStreakDays = currentStreakDays
        self.nextMilestoneDays = nextMilestoneDays
        self.completedMilestones = completedMilestones
        self.month = month
        self.checkedDays = checkedDays
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                nextMilestoneCard
                milestoneHistory
                consistencyCalendar
                quoteCard
            }
            .padding(16)
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { trailingMenu }
    }

    // MARK: - Header (Streak)
    private var header: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                VStack(spacing: 8) {
                    Text("DAY STREAK")
                        .font(.caption2.weight(.heavy))
                        .foregroundColor(Color.theme.secondaryText)
                    Text("\(currentStreakDays)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.theme.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.theme.accent.opacity(0.15), lineWidth: 1)
            )
        }
    }

    // MARK: - Next Milestone
    private var nextMilestoneCard: some View {
        let progress = min(Double(currentStreakDays) / Double(max(nextMilestoneDays, 1)), 1.0)
        return VStack(alignment: .leading, spacing: 12) {
            Text("Next Milestone")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("\(currentStreakDays) / \(nextMilestoneDays) days")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                    Spacer()
                }
                ProgressView(value: progress)
                    .tint(Color.blue)
                    .padding(.vertical, 2)
                Text("\(nextMilestoneDays - min(currentStreakDays, nextMilestoneDays)) days until \(nextMilestoneDays)-Day Badge")
                    .font(.caption)
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(14)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
        }
    }

    // MARK: - Milestone History
    private var milestoneHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Milestone History")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                Button("View all") {}
                    .font(.caption.weight(.heavy))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.blue.opacity(0.2)))
                    .foregroundColor(.blue)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(completedMilestones) { m in
                        VStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.theme.accent.opacity(0.12))
                                    .frame(width: 80, height: 80)
                                Image(systemName: m.icon)
                                    .font(.title2)
                                    .foregroundColor(m.color)
                            }
                            Text(m.title)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(Color.theme.accent)
                                .multilineTextAlignment(.center)
                                .frame(width: 90)
                        }
                        .padding(8)
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: - Consistency Calendar
    private var consistencyCalendar: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(monthTitle(for: month))
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)

            let grid = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
            LazyVGrid(columns: grid, spacing: 8) {
                // Weekday headers
                ForEach(["S","M","T","W","T","F","S"], id: \.self) { d in
                    Text(d)
                        .font(.caption2.weight(.heavy))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity)
                }

                // Days grid
                ForEach(daysForMonth(month), id: \.self) { day in
                    if day == 0 {
                        Color.clear.frame(height: 36)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(checkedDays.contains(day) ? Color.blue : Color.theme.accent.opacity(0.12))
                            Image(systemName: checkedDays.contains(day) ? "checkmark" : "")
                                .font(.caption.bold())
                                .foregroundColor(checkedDays.contains(day) ? .white : .clear)
                        }
                        .frame(height: 36)
                        .overlay(
                            Text("\(day)")
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(checkedDays.contains(day) ? .white : Color.theme.accent)
                        )
                    }
                }
            }
            .padding(14)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
        }
    }

    // MARK: - Quote
    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\"Consistency is the key to clarity. Every entry is a step closer to understanding yourself.\"")
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var trailingMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .tint(Color.theme.accent)
        }
    }

    // MARK: - Helpers
    private func monthTitle(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "LLLL yyyy"
        return f.string(from: date)
    }

    private func daysForMonth(_ date: Date) -> [Int] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday
        let range = calendar.range(of: .day, in: .month, for: date) ?? 1..<29
        let comps = calendar.dateComponents([.year, .month], from: date)
        let firstOfMonth = calendar.date(from: comps) ?? date
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingEmpty = (weekday - calendar.firstWeekday + 7) % 7
        let days = Array(range)
        return Array(repeating: 0, count: leadingEmpty) + days
    }
}

struct Milestone: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
}

#Preview {
    NavigationStack {
        StreaksProgressView()
    }
}
