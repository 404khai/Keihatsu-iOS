import Combine
import Foundation

@MainActor
final class AppEnvironment: ObservableObject {
    let services: AppServices
    let theme: KeihatsuTheme

    init(
        services: AppServices = .preview,
        theme: KeihatsuTheme? = nil
    ) {
        self.services = services
        self.theme = theme ?? .default
    }
}

struct AppServices {
    let apiBaseURL: URL?
    let imageHostURL: URL?
    let readerPrefetchWindow: Int

    static let preview = AppServices(
        apiBaseURL: nil,
        imageHostURL: nil,
        readerPrefetchWindow: 3
    )
}
