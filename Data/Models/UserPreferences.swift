import Foundation

struct LocalUserPreferences: Codable, Equatable {
    var accentHex: String
    var appIcon: AppIconPreference
    var colorScheme: AppColorSchemePreference
    var readerDirection: ReaderDirectionPreference
    var readerBackground: ReaderBackgroundPreference
    var keepScreenAwake: Bool
    var incognitoModeEnabled: Bool
    var autoSyncEnabled: Bool
    var downloadOnWiFiOnly: Bool
    var saveChaptersForOffline: Bool
    var showChapterBadges: Bool
    var globalLibraryUpdatesEnabled: Bool
    var sourceWarningsEnabled: Bool
    var trackingSyncEnabled: Bool
    var diagnosticsEnabled: Bool

    init(
        accentHex: String,
        appIcon: AppIconPreference,
        colorScheme: AppColorSchemePreference,
        readerDirection: ReaderDirectionPreference,
        readerBackground: ReaderBackgroundPreference,
        keepScreenAwake: Bool,
        incognitoModeEnabled: Bool,
        autoSyncEnabled: Bool,
        downloadOnWiFiOnly: Bool,
        saveChaptersForOffline: Bool,
        showChapterBadges: Bool,
        globalLibraryUpdatesEnabled: Bool,
        sourceWarningsEnabled: Bool,
        trackingSyncEnabled: Bool,
        diagnosticsEnabled: Bool
    ) {
        self.accentHex = accentHex
        self.appIcon = appIcon
        self.colorScheme = colorScheme
        self.readerDirection = readerDirection
        self.readerBackground = readerBackground
        self.keepScreenAwake = keepScreenAwake
        self.incognitoModeEnabled = incognitoModeEnabled
        self.autoSyncEnabled = autoSyncEnabled
        self.downloadOnWiFiOnly = downloadOnWiFiOnly
        self.saveChaptersForOffline = saveChaptersForOffline
        self.showChapterBadges = showChapterBadges
        self.globalLibraryUpdatesEnabled = globalLibraryUpdatesEnabled
        self.sourceWarningsEnabled = sourceWarningsEnabled
        self.trackingSyncEnabled = trackingSyncEnabled
        self.diagnosticsEnabled = diagnosticsEnabled
    }

    init(from decoder: Decoder) throws {
        let defaults = LocalUserPreferences.default
        let container = try decoder.container(keyedBy: CodingKeys.self)

        accentHex = try container.decodeIfPresent(String.self, forKey: .accentHex) ?? defaults.accentHex
        appIcon = try container.decodeIfPresent(AppIconPreference.self, forKey: .appIcon) ?? defaults.appIcon
        colorScheme = try container.decodeIfPresent(AppColorSchemePreference.self, forKey: .colorScheme) ?? defaults.colorScheme
        readerDirection = try container.decodeIfPresent(ReaderDirectionPreference.self, forKey: .readerDirection) ?? defaults.readerDirection
        readerBackground = try container.decodeIfPresent(ReaderBackgroundPreference.self, forKey: .readerBackground) ?? defaults.readerBackground
        keepScreenAwake = try container.decodeIfPresent(Bool.self, forKey: .keepScreenAwake) ?? defaults.keepScreenAwake
        incognitoModeEnabled = try container.decodeIfPresent(Bool.self, forKey: .incognitoModeEnabled) ?? defaults.incognitoModeEnabled
        autoSyncEnabled = try container.decodeIfPresent(Bool.self, forKey: .autoSyncEnabled) ?? defaults.autoSyncEnabled
        downloadOnWiFiOnly = try container.decodeIfPresent(Bool.self, forKey: .downloadOnWiFiOnly) ?? defaults.downloadOnWiFiOnly
        saveChaptersForOffline = try container.decodeIfPresent(Bool.self, forKey: .saveChaptersForOffline) ?? defaults.saveChaptersForOffline
        showChapterBadges = try container.decodeIfPresent(Bool.self, forKey: .showChapterBadges) ?? defaults.showChapterBadges
        globalLibraryUpdatesEnabled = try container.decodeIfPresent(Bool.self, forKey: .globalLibraryUpdatesEnabled) ?? defaults.globalLibraryUpdatesEnabled
        sourceWarningsEnabled = try container.decodeIfPresent(Bool.self, forKey: .sourceWarningsEnabled) ?? defaults.sourceWarningsEnabled
        trackingSyncEnabled = try container.decodeIfPresent(Bool.self, forKey: .trackingSyncEnabled) ?? defaults.trackingSyncEnabled
        diagnosticsEnabled = try container.decodeIfPresent(Bool.self, forKey: .diagnosticsEnabled) ?? defaults.diagnosticsEnabled
    }

    static let `default` = LocalUserPreferences(
        accentHex: "92BB57",
        appIcon: .default,
        colorScheme: .system,
        readerDirection: .vertical,
        readerBackground: .system,
        keepScreenAwake: true,
        incognitoModeEnabled: false,
        autoSyncEnabled: true,
        downloadOnWiFiOnly: true,
        saveChaptersForOffline: false,
        showChapterBadges: true,
        globalLibraryUpdatesEnabled: true,
        sourceWarningsEnabled: true,
        trackingSyncEnabled: false,
        diagnosticsEnabled: false
    )
}

enum AppIconPreference: String, Codable, CaseIterable, Identifiable {
    case `default`
    case dark
    case light

    var id: String { rawValue }

    var label: String {
        switch self {
        case .default: return "Default"
        case .dark: return "Dark"
        case .light: return "Light"
        }
    }
}

enum AppColorSchemePreference: String, Codable, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

enum ReaderDirectionPreference: String, Codable, CaseIterable, Identifiable {
    case vertical
    case leftToRight
    case rightToLeft

    var id: String { rawValue }

    var label: String {
        switch self {
        case .vertical: return "Vertical"
        case .leftToRight: return "Left to Right"
        case .rightToLeft: return "Right to Left"
        }
    }
}

enum ReaderBackgroundPreference: String, Codable, CaseIterable, Identifiable {
    case system
    case black
    case paper

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "System"
        case .black: return "Black"
        case .paper: return "Paper"
        }
    }
}
