import SwiftUI

struct SettingsView: View {
    var body: some View {
        PlaceholderFeatureView(
            title: "Settings",
            summary: "Phase 0 keeps system-facing preferences isolated so future reader defaults and app controls have a stable home.",
            nextMilestone: "Layer in app preferences, reader defaults, and download controls with reusable settings row primitives."
        )
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
