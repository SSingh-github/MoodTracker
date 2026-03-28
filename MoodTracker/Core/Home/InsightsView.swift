//
//  InsightsView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct InsightsView: View {
    enum Period: String, CaseIterable { case week = "Week", month = "Month", year = "Year" }
    @State private var period: Period = .week

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    periodSelector
                    weeklyTrendCard
                    keyPatternsSection
                    moodDistributionCard
                    upgradeCard
                }
                .padding(16)
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Mood Insights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { trailingMenu }
        }
    }

    private var header: some View { EmptyView() }

    private var periodSelector: some View {
        HStack(spacing: 8) {
            ForEach(Period.allCases, id: \.self) { p in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { period = p }
                } label: {
                    Text(p.rawValue)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(period == p ? .white : Color.theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if period == p {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.theme.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color.theme.accent.opacity(0.08))
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
    }

    private var weeklyTrendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Weekly Mood Trend")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color.theme.secondaryText)
                    HStack(spacing: 8) {
                        Text("Stable")
                            .font(.title3.weight(.bold))
                            .foregroundColor(Color.theme.accent)
                        Text("+12%")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.green.opacity(0.2)))
                    }
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                }
                .tint(Color.theme.accent)
            }

            // Simple line visualization placeholder
            TrendLine()
                .frame(height: 140)
                .padding(.top, 4)

            HStack {
                ForEach(["M","T","W","T","F","S","S"], id: \.self) { d in
                    Text(d)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(Color.theme.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    private var keyPatternsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Key Patterns")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                Button("AI ANALYSIS") {}
                    .font(.caption.weight(.heavy))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.blue.opacity(0.2)))
                    .foregroundColor(.blue)
            }

            VStack(spacing: 12) {
                patternRow(icon: "moon.zzz.fill", title: "Sleep Correlation", subtitle: "You feel 24% calmer after 7+ hours of sleep.", badge: nil, locked: false)
                patternRow(icon: "sparkles", title: "Peak Joy", subtitle: "Your mood peaks consistently on Tuesday afternoons.", badge: nil, locked: false)
                patternRow(icon: "cloud.sun", title: "Weather Insight", subtitle: "Unlock to see how weather affects you.", badge: Image(systemName: "lock.fill"), locked: true)
            }
            .padding(14)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
        }
    }

    private func patternRow(icon: String, title: String, subtitle: String, badge: Image?, locked: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.theme.accent.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundColor(Color.theme.accent)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundColor(Color.theme.accent)
                    if let badge { badge.foregroundColor(Color.theme.secondaryText) }
                }
                Text(subtitle)
                    .font(.footnote)
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
        }
    }

    private var moodDistributionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Distribution")
                .font(.headline.weight(.semibold))
                .foregroundColor(Color.theme.accent)

            HStack(alignment: .center) {
                DonutChart(values: [40, 25, 20, 15], colors: [.green, .yellow, .orange, .blue])
                    .frame(width: 120, height: 120)
                VStack(alignment: .leading, spacing: 6) {
                    Text("TOTAL")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(Color.theme.secondaryText)
                    Text("28")
                        .font(.title2.weight(.bold))
                        .foregroundColor(Color.theme.accent)
                    legendItem(color: .green, text: "Calm (40%)")
                    legendItem(color: .yellow, text: "Joy (25%)")
                    legendItem(color: .orange, text: "Tired (20%)")
                    legendItem(color: .blue, text: "Anxious (15%)")
                }
                Spacer()
            }
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
        }
    }

    private var upgradeCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Advanced Correlations")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Text("PREMIUM FEATURE")
                    .font(.caption2.weight(.heavy))
                    .foregroundColor(Color.theme.secondaryText)
            }
            Spacer()
            Button("Upgrade") {}
                .font(.callout.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.blue))
                .foregroundColor(.white)
        }
        .padding(16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }

    @ToolbarContentBuilder
    private var trailingMenu: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .tint(Color.theme.accent)
        }
    }
}

// MARK: - Simple visuals

private struct TrendLine: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.theme.accent.opacity(0.08))
                Path { path in
                    let w = geo.size.width
                    let h = geo.size.height
                    let points: [CGPoint] = [
                        .init(x: w*0.0, y: h*0.6),
                        .init(x: w*0.15, y: h*0.5),
                        .init(x: w*0.3, y: h*0.65),
                        .init(x: w*0.5, y: h*0.35),
                        .init(x: w*0.7, y: h*0.55),
                        .init(x: w*0.9, y: h*0.4),
                        .init(x: w*1.0, y: h*0.5)
                    ]
                    guard let first = points.first else { return }
                    path.move(to: first)
                    for p in points.dropFirst() { path.addLine(to: p) }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .shadow(color: Color.blue.opacity(0.3), radius: 6, x: 0, y: 3)
            }
        }
    }
}

private struct DonutChart: View {
    let values: [Double]
    let colors: [Color]

    var total: Double { values.reduce(0, +) }

    var body: some View {
        ZStack {
            let totalSafe = max(total, 0.0001)
            let segments: [(start: Angle, end: Angle, color: Color)] = {
                var result: [(Angle, Angle, Color)] = []
                var currentStart: Angle = .degrees(-90)
                for (i, value) in values.enumerated() {
                    let delta = Angle.degrees(360 * (value / totalSafe))
                    let end = currentStart + delta
                    let color = colors[i % colors.count]
                    result.append((currentStart, end, color))
                    currentStart = end
                }
                return result
            }()

            ForEach(segments.indices, id: \.self) { i in
                let seg = segments[i]
                CircleSegment(startAngle: seg.start, endAngle: seg.end)
                    .fill(seg.color)
            }

            Circle()
                .fill(Color.theme.background)
                .frame(width: 60, height: 60)
        }
    }
}

private struct CircleSegment: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        return path
    }
}

#Preview {
    InsightsView()
}
