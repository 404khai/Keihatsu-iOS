import SwiftUI

struct LibraryView: View {
    var body: some View {
        PlaceholderFeatureView(
            title: "Library",
            summary: "Phase 0 reserves Library for collection state, reading progress, and offline ownership without leaking persistence into the view layer.",
            nextMilestone: "Introduce list and grid organization, state filters, and collection affordances backed by placeholder data in Phase 2."
        )
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
    }
}
