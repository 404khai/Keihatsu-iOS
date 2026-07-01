//
//  PluginsView.swift
//  Keihatsu-iOS
//
//  Created by admin on 6/3/26.
//


import SwiftUI

struct PluginsView: View {
    @State private var selectedTab: PluginsTab = .sources
    @State private var searchText = ""

    private let sourceItems: [PluginSource] = [
        PluginSource(name: "Atsumaru", assetName: "atsumaru", subtitle: "EN • https://atsumaru.example", status: "Available now", isEnabled: true),
        PluginSource(name: "BatCave", assetName: "batcave", subtitle: "EN • https://batcave.example", status: "Installed", isEnabled: true),
        PluginSource(name: "MangaFire", assetName: "mangafire", subtitle: "EN • https://mangafire.example", status: "Available now", isEnabled: false),
        PluginSource(name: "ManhuaTop", assetName: "manhuatop", subtitle: "EN • https://manhuatop.example", status: "Available now", isEnabled: true),
        PluginSource(name: "WeebCentral", assetName: "weebcentral", subtitle: "EN • https://weebcentral.example", status: "Disabled", isEnabled: false)
    ]

    private var filteredSourceItems: [PluginSource] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return sourceItems }

        return sourceItems.filter { item in
            item.name.localizedCaseInsensitiveContains(query)
            || item.subtitle.localizedCaseInsensitiveContains(query)
            || item.status.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Picker("Extensions Tab", selection: $selectedTab) {
                    ForEach(PluginsTab.allCases, id: \.self) { tab in
                        Text(tab.title).tag(tab)
                    }
                }
                .pickerStyle(.segmented)

                VStack(spacing: 14) {
                    switch selectedTab {
                    case .sources:
                        ForEach(filteredSourceItems) { item in
                            PluginCard(item: item)
                        }
                    case .plugins:
                        PluginPlaceholderCard(
                            title: "Plugin Store",
                            subtitle: "Browse community plugins and install them here."
                        )
                        PluginPlaceholderCard(
                            title: "Recommended",
                            subtitle: "Discover popular sources curated for your library."
                        )
                    case .migrate:
                        PluginPlaceholderCard(
                            title: "Migrate Sources",
                            subtitle: "Move your saved sources and settings between plugins."
                        )
                        PluginPlaceholderCard(
                            title: "Sync History",
                            subtitle: "Keep reading state consistent after migration."
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Plugins")
        .navigationBarTitleDisplayMode(.automatic)
        .searchable(text: $searchText, placement: .toolbar, prompt: Text("Search plugins"))
//        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
//        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

private struct PluginCard: View {
    let item: PluginSource
    @State private var isEnabled: Bool

    init(item: PluginSource) {
        self.item = item
        _isEnabled = State(initialValue: item.isEnabled)
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(item.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Text(item.status)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(isEnabled ? .green : .secondary)
            }

            Spacer(minLength: 0)

            VStack(spacing: 14) {
                Image(systemName: "pin")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Toggle("", isOn: $isEnabled)
                    .labelsHidden()
                    .tint(.accentColor)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
        }
    }
}

private struct PluginPlaceholderCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
        }
    }
}

private enum PluginsTab: CaseIterable {
    case sources
    case plugins
    case migrate

    var title: String {
        switch self {
        case .sources: return "Sources"
        case .plugins: return "Plugins"
        case .migrate: return "Migrate"
        }
    }
}

private struct PluginSource: Identifiable {
    let id = UUID()
    let name: String
    let assetName: String
    let subtitle: String
    let status: String
    let isEnabled: Bool
}

#Preview {
    NavigationStack {
        PluginsView()
    }
}
