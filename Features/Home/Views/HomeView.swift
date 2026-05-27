import SwiftUI

struct HomeView: View {
    var body: some View {
        PlaceholderFeatureView(
            title: "Home",
            summary: "Phase 0 keeps Home as a placeholder root so discovery UI can plug into stable architecture in Phase 2.",
            nextMilestone: "Build the browsing surface, continue-reading modules, and promotional content hierarchy with reusable cards and sections."
        )
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
