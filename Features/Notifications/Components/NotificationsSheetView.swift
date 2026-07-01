import SwiftUI

struct NotificationsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var preferencesStore: AppPreferencesStore
    @State private var selectedTab: NotificationTab = .all
    @State private var notifications: [KeihatsuNotification] = KeihatsuNotification.samples
    @State private var selectionMode = false
    @State private var selectedIDs: Set<UUID> = []

    private var accent: Color {
        Color(hex: preferencesStore.preferences.theme.hex)
    }

    private var filteredNotifications: [KeihatsuNotification] {
        notifications.filter { notification in
            selectedTab == .all || notification.tab == selectedTab
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Notifications", selection: $selectedTab) {
                    ForEach(NotificationTab.allCases) { tab in
                        Text(tab.title).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 10)

                List {
                    ForEach(filteredNotifications) { notification in
                        NotificationRow(
                            notification: notification,
                            isSelected: selectedIDs.contains(notification.id),
                            selectionMode: selectionMode,
                            accent: accent
                        ) {
                            toggleSelection(for: notification.id)
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            if selectionMode {
                                toggleSelection(for: notification.id)
                            } else {
                                markRead(notification.id)
                            }
                        }
                        .onLongPressGesture {
                            selectionMode = true
                            selectedIDs = [notification.id]
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteNotifications(Set([notification.id]))
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                markRead(notification.id)
                            } label: {
                                Label(notification.isRead ? "Mark Unread" : "Mark Read", systemImage: notification.isRead ? "circle" : "checkmark.circle.fill")
                            }
                            .tint(notification.isRead ? .gray : accent)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if selectionMode {
                            selectionMode = false
                            selectedIDs.removeAll()
                        } else {
                            dismiss()
                        }
                    } label: {
                        if selectionMode {
                            Text("Done")
                        } else {
                            Image(systemName: "xmark")
                                .font(.headline.weight(.semibold))
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if selectionMode {
                        Button(role: .destructive) {
                            deleteNotifications(selectedIDs)
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                        .disabled(selectedIDs.isEmpty)
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    private func markRead(_ id: UUID) {
        guard let index = notifications.firstIndex(where: { $0.id == id }) else { return }
        notifications[index].isRead.toggle()
    }

    private func toggleSelection(for id: UUID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }

    private func deleteNotifications(_ ids: Set<UUID>) {
        notifications.removeAll { ids.contains($0.id) }
        selectedIDs.subtract(ids)
        if selectedIDs.isEmpty {
            selectionMode = false
        }
    }
}

private struct NotificationRow: View {
    let notification: KeihatsuNotification
    let isSelected: Bool
    let selectionMode: Bool
    let accent: Color
    let onToggleSelection: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            if selectionMode {
                Button(action: onToggleSelection) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(isSelected ? accent : .secondary)
                }
                .buttonStyle(.plain)
            }

            Image(systemName: notification.icon)
                .font(.headline)
                .foregroundStyle(accent)
                .frame(width: 42, height: 42)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 13, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(notification.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    if !notification.isRead {
                        Circle()
                            .fill(accent)
                            .frame(width: 7, height: 7)
                    }
                }

                Text(notification.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(notification.time)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(isSelected ? accent.opacity(0.12) : Color(.secondarySystemGroupedBackground))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(isSelected ? accent.opacity(0.38) : Color(.separator).opacity(0.25), lineWidth: 1)
        }
    }
}

private enum NotificationTab: String, CaseIterable, Identifiable {
    case all
    case updates
    case system

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "All"
        case .updates: return "Updates"
        case .system: return "System"
        }
    }
}

private struct KeihatsuNotification: Identifiable {
    let id = UUID()
    let tab: NotificationTab
    let icon: String
    let title: String
    let message: String
    let time: String
    var isRead: Bool

    static let samples: [KeihatsuNotification] = [
        KeihatsuNotification(tab: .updates, icon: "book.closed.fill", title: "New Chapter", message: "Ordeal Chapter 158 is ready in your library.", time: "2m ago", isRead: false),
        KeihatsuNotification(tab: .updates, icon: "arrow.down.circle.fill", title: "Download Complete", message: "3 chapters from Latna Saga are available offline.", time: "18m ago", isRead: false),
        KeihatsuNotification(tab: .system, icon: "icloud.fill", title: "Sync Queued", message: "Reading history will sync when your account session refreshes.", time: "1h ago", isRead: true),
        KeihatsuNotification(tab: .system, icon: "puzzlepiece.extension.fill", title: "Source Warning", message: "MangaFire is responding slowly. Try again later if pages fail.", time: "3h ago", isRead: false),
        KeihatsuNotification(tab: .updates, icon: "sparkles", title: "Trending Now", message: "The World After the Fall is climbing in your recommendations.", time: "Yesterday", isRead: true)
    ]
}

#Preview {
    NotificationsSheetView()
        .environmentObject(AppPreferencesStore(userDefaults: .standard))
}
