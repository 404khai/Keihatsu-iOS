import SwiftUI

struct ProfileView: View {
    var body: some View {
        PlaceholderFeatureView(
            title: "Profile",
            summary: "Phase 0 gives profile and account surfaces a dedicated feature root before authentication and session logic arrive.",
            nextMilestone: "Add user identity surfaces, reading stats, and account-linked actions that can later become session aware."
        )
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
