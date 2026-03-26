//
//  HistoryTabView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct HistoryTabView: View {
    enum Mode: String, CaseIterable { case list = "List", calendar = "Calendar" }
    @State private var mode: Mode = .list
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                VStack(spacing: 16) {
                    header
                    searchBar
                    segmented
                    content
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { topBarButtons }
        }
    }

    private var header: some View { EmptyView() }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            TextField("Search your entries…", text: $searchText)
                .textFieldStyle(.plain)
                .foregroundColor(Color.theme.accent)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
    }

    private var segmented: some View {
        HStack(spacing: 8) {
            ForEach(Mode.allCases, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) { mode = item }
                } label: {
                    Text(item.rawValue)
                        .font(.callout.weight(.semibold))
                        .foregroundColor(mode == item ? .white : Color.theme.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if mode == item {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.theme.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.theme.accent.opacity(0.08))
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

    @ViewBuilder
    private var content: some View {
        switch mode {
        case .list:
            HistoryListView()
        case .calendar:
            HistoryCalendarView()
        }
    }

    @ToolbarContentBuilder
    private var topBarButtons: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "bell")
                }
                Button(action: {}) {
                    Image(systemName: "gearshape")
                }
            }
            .tint(Color.theme.accent)
        }
    }
}

#Preview {
    HistoryTabView()
}
