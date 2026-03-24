//
//  SettingsView.swift
//  MoodTracker
//
//  Created by Assistant on 10/03/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var iCloudSync: Bool = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    accountSection
                    appSettingsSection
                    dataPrivacySection
                    footer
                }
                .padding(16)
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Sections

    private var accountSection: some View {
        VStack(spacing: 12) {
            sectionHeader("Account")
            Button(action: {}) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.theme.accent.opacity(0.2)).frame(width: 54, height: 54)
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(Color.theme.accent)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Alex Rivers")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(Color.theme.accent)
                        Text("alex.rivers@me.com")
                            .font(.footnote)
                            .foregroundColor(Color.theme.secondaryText)
                        HStack(spacing: 6) {
                            Text("Pro Member • Active")
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.green))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.theme.secondaryText)
                }
                .padding(14)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var appSettingsSection: some View {
        VStack(spacing: 12) {
            sectionHeader("App Settings")
            VStack(spacing: 10) {
                settingsRow(icon: "paintbrush", title: "Appearance", detail: "System")
                divider
                settingsRow(icon: "bell", title: "Notifications", detail: nil)
                divider
                settingsRow(icon: "lock", title: "FaceID & Passcode", detail: nil)
            }
            .padding(14)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
        }
    }

    private var dataPrivacySection: some View {
        VStack(spacing: 12) {
            sectionHeader("Data & Privacy")
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    iconBox("icloud")
                    VStack(alignment: .leading, spacing: 2) {
                        Text("iCloud Sync")
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.theme.accent)
                        Text("Encrypted")
                            .font(.caption.weight(.medium))
                            .foregroundColor(Color.green)
                    }
                    Spacer()
                    Toggle("", isOn: $iCloudSync)
                        .labelsHidden()
                }
                divider
                navigationRow(icon: "square.and.arrow.up", title: "Export Journal Data")
                divider
                Button(action: {}) {
                    HStack(spacing: 12) {
                        iconBox("trash")
                            .foregroundStyle(Color.red)
                        Text("Clear All Data")
                            .font(.body.weight(.semibold))
                            .foregroundColor(Color.red)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 18, style: .continuous)
            )
        }
    }

    private var footer: some View {
        VStack(spacing: 6) {
            Text("Zen Journal v2.4.0")
                .font(.footnote.weight(.semibold))
                .foregroundColor(Color.theme.secondaryText)
            Text("Made with ❤ for mental health awareness.")
                .font(.footnote)
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Components

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundColor(Color.theme.secondaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func settingsRow(icon: String, title: String, detail: String?) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                iconBox(icon)
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                if let detail { Text(detail).foregroundColor(Color.theme.secondaryText) }
                Image(systemName: "chevron.right").foregroundColor(Color.theme.secondaryText)
            }
        }
        .buttonStyle(.plain)
    }

    private func navigationRow(icon: String, title: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                iconBox(icon)
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundColor(Color.theme.accent)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(Color.theme.secondaryText)
            }
        }
        .buttonStyle(.plain)
    }

    private var divider: some View {
        Rectangle().fill(Color.white.opacity(0.06)).frame(height: 1)
    }

    private func iconBox(_ systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.theme.accent.opacity(0.12))
                .frame(width: 36, height: 36)
            Image(systemName: systemName)
                .foregroundColor(Color.theme.accent)
        }
    }
}

#Preview {
    ZStack { Color.theme.background.ignoresSafeArea() }
    SettingsView()
}
