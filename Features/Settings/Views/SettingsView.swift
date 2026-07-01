import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var preferencesStore: AppPreferencesStore
    @EnvironmentObject private var syncQueueStore: SyncQueueStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                SettingsHeroCard()

                SettingsGroup(title: "Appearance") {
                    Picker("Theme", selection: $preferencesStore.preferences.colorScheme) {
                        ForEach(AppColorSchemePreference.allCases) { option in
                            Text(option.label).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    SettingsPickerRow(
                        icon: "app.dashed",
                        title: "App Icon",
                        subtitle: "Choose the launcher identity",
                        selection: $preferencesStore.preferences.appIcon,
                        options: AppIconPreference.allCases
                    )
                }

                SettingsGroup(title: "Reader") {
                    SettingsPickerRow(
                        icon: "rectangle.portrait.on.rectangle.portrait",
                        title: "Reading Direction",
                        subtitle: "Default flow for new chapters",
                        selection: $preferencesStore.preferences.readerDirection,
                        options: ReaderDirectionPreference.allCases
                    )

                    SettingsDivider()

                    SettingsPickerRow(
                        icon: "circle.lefthalf.filled",
                        title: "Reader Background",
                        subtitle: "Comfort mode for long sessions",
                        selection: $preferencesStore.preferences.readerBackground,
                        options: ReaderBackgroundPreference.allCases
                    )

                    SettingsDivider()

                    SettingsToggleRow(
                        icon: "iphone",
                        title: "Keep Screen Awake",
                        subtitle: "Prevent dimming while reading",
                        isOn: $preferencesStore.preferences.keepScreenAwake
                    )
                }

                SettingsGroup(title: "Downloads") {
                    SettingsToggleRow(
                        icon: "wifi",
                        title: "Wi-Fi Only",
                        subtitle: "Queue chapter downloads until Wi-Fi is available",
                        isOn: $preferencesStore.preferences.downloadOnWiFiOnly
                    )

                    SettingsDivider()

                    SettingsToggleRow(
                        icon: "arrow.down.doc",
                        title: "Save Chapters",
                        subtitle: "Keep downloaded chapters available offline",
                        isOn: $preferencesStore.preferences.saveChaptersForOffline
                    )
                }

                SettingsGroup(title: "Library") {
                    SettingsToggleRow(
                        icon: "books.vertical",
                        title: "Global Updates",
                        subtitle: "Refresh saved titles when the session syncs",
                        isOn: $preferencesStore.preferences.globalLibraryUpdatesEnabled
                    )

                    SettingsDivider()

                    SettingsToggleRow(
                        icon: "number.circle",
                        title: "Library Badges",
                        subtitle: "Surface unread, downloaded, and update indicators",
                        isOn: $preferencesStore.preferences.showChapterBadges
                    )
                }

                SettingsGroup(title: "Browse") {
                    SettingsToggleRow(
                        icon: "puzzlepiece.extension",
                        title: "Source Warnings",
                        subtitle: "Show availability and safety hints for plugins",
                        isOn: $preferencesStore.preferences.sourceWarningsEnabled
                    )
                }

                SettingsGroup(title: "Tracking") {
                    SettingsToggleRow(
                        icon: "point.3.connected.trianglepath.dotted",
                        title: "External Tracking",
                        subtitle: "Prepare progress sync for services like MyAnimeList",
                        isOn: $preferencesStore.preferences.trackingSyncEnabled
                    )
                }

                SettingsGroup(title: "Privacy") {
                    SettingsToggleRow(
                        icon: "theatermasks.fill",
                        title: "Incognito Mode",
                        subtitle: "Read without saving history",
                        isOn: $preferencesStore.preferences.incognitoModeEnabled
                    )
                }

                SettingsGroup(title: "Sync") {
                    SettingsToggleRow(
                        icon: "arrow.triangle.2.circlepath",
                        title: "Auto Sync",
                        subtitle: "Keep library, history, bookmarks, and preferences ready for backend sync",
                        isOn: $preferencesStore.preferences.autoSyncEnabled
                    )

                    SettingsDivider()

                    syncStatus
                }

                SettingsGroup(title: "Advanced") {
                    SettingsToggleRow(
                        icon: "waveform.path.ecg",
                        title: "Diagnostics",
                        subtitle: "Keep local logs for sync, reader, and source debugging",
                        isOn: $preferencesStore.preferences.diagnosticsEnabled
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 34)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset") {
                    preferencesStore.reset()
                }
            }
        }
    }

    private var syncStatus: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                SettingsIcon(symbol: "icloud.and.arrow.up")

                VStack(alignment: .leading, spacing: 5) {
                    Text("\(syncQueueStore.pendingCount) pending operation\(syncQueueStore.pendingCount == 1 ? "" : "s")")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(lastSyncedText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Button("Sync Now") {
                    syncQueueStore.markAllCompleted()
                }
                .buttonStyle(.borderedProminent)
            }

            ForEach(syncQueueStore.operations.prefix(3)) { operation in
                HStack(spacing: 10) {
                    Circle()
                        .fill(statusColor(for: operation.status))
                        .frame(width: 8, height: 8)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(operation.kind.label)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary)

                        Text(operation.summary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)

                    Text(operation.status.label)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    private var lastSyncedText: String {
        guard let lastSyncedAt = syncQueueStore.lastSyncedAt else {
            return "Not synced yet"
        }

        return "Last synced \(lastSyncedAt.formatted(date: .abbreviated, time: .shortened))"
    }

    private func statusColor(for status: SyncOperationStatus) -> Color {
        switch status {
        case .queued: return Color.keihatsuAccent
        case .syncing: return .blue
        case .failed: return .red
        case .completed: return .green
        }
    }
}

private struct SettingsHeroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Keihatsu Controls", systemImage: "sparkles")
                .font(.headline)
                .foregroundStyle(Color.keihatsuAccent)

            Text("Tune the app shell, reader defaults, privacy, downloads, and sync behavior from one native iOS surface.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content
            }
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            SettingsIcon(symbol: icon)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .tint(Color.keihatsuAccent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

private struct SettingsPickerRow<Option: Identifiable & Hashable>: View where Option.AllCases: RandomAccessCollection, Option: CaseIterable {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var selection: Option
    let options: Option.AllCases

    var body: some View {
        HStack(spacing: 14) {
            SettingsIcon(symbol: icon)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            Picker(title, selection: $selection) {
                ForEach(options) { option in
                    Text(label(for: option)).tag(option)
                }
            }
            .tint(Color.keihatsuAccent)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    private func label(for option: Option) -> String {
        switch option {
        case let option as AppIconPreference:
            return option.label
        case let option as ReaderDirectionPreference:
            return option.label
        case let option as ReaderBackgroundPreference:
            return option.label
        default:
            return String(describing: option)
        }
    }
}

private struct SettingsIcon: View {
    let symbol: String

    var body: some View {
        Image(systemName: symbol)
            .font(.title3.weight(.medium))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(Color.keihatsuAccent)
            .frame(width: 36, height: 36)
            .background(Color.keihatsuAccent.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct SettingsDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 66)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AppPreferencesStore(userDefaults: .standard))
            .environmentObject(SyncQueueStore())
    }
}
