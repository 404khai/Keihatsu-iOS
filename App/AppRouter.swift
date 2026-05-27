import Combine
import SwiftUI

enum AppRoute: Hashable {
    case feature(FeatureDestination)
}

enum FeatureDestination: String, Hashable, CaseIterable, Identifiable {
    case home = "Home"
    case search = "Search"
    case library = "Library"
    case profile = "Profile"
    case settings = "Settings"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass"
        case .library:
            return "books.vertical.fill"
        case .profile:
            return "person.crop.circle.fill"
        case .settings:
            return "gearshape.fill"
        }
    }

    var summary: String {
        switch self {
        case .home:
            return "Content-first landing surface for discovery, promotions, and continue reading."
        case .search:
            return "Native search architecture with room for filters, recents, and remote suggestions."
        case .library:
            return "Collection management, reading states, and offline affordances flow through here."
        case .profile:
            return "Account surfaces, achievements, and reading identity anchor in this feature root."
        case .settings:
            return "App preferences, reading defaults, and system-facing controls live here."
        }
    }
}

@MainActor
final class AppRouter: ObservableObject {
    enum RootDestination {
        case scaffold
    }

    @Published var rootDestination: RootDestination = .scaffold
    @Published var path = NavigationPath()

    func open(_ destination: FeatureDestination) {
        path.append(AppRoute.feature(destination))
    }

    func resetToRoot() {
        path = NavigationPath()
    }
}
