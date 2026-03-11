//
//  MainTabView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var isPresentingQuickLog: Bool = false
    @State private var selectedMoodForQuickLog: Int? = nil

    var body: some View {
        TabView(selection: $selectedTab) {

            // Home
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)

            // Insights
            InsightsView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Insights")
                }
                .tag(1)

            // Add button tab
            Color.clear
                .tabItem {
                    ZStack {
                        Circle()
                            .fill(Color.theme.accent)
                            .frame(width: 54, height: 54)
                            .shadow(color: Color.theme.accent.opacity(0.5), radius: 12, x: 0, y: 6)

                        Image(systemName: "plus")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                .tag(2)

            // History
            HistoryTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                .tag(3)

            // Settings
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .tint(Color.theme.accent)

        // Detect tab change (iOS 17+ onChange signature)
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                presentQuickLog()
                // move back to Home so Add doesn't stay selected
                selectedTab = oldValue
            }
        }

        // Present Full Screen Sheet
        .fullScreenCover(isPresented: $isPresentingQuickLog) {
            AddNewLogFlowView()
        }
    }

    private func presentQuickLog() {
        selectedMoodForQuickLog = nil
        isPresentingQuickLog = true
    }
}

struct PlaceholderTabView: View {
    let title: String

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundColor(Color.theme.accent)
        }
    }
}
#Preview {
    MainTabView()
}
