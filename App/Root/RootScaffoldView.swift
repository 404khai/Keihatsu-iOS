import SwiftUI

struct RootScaffoldView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.keihatsuTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xxxl) {
                header
                architectureCard
                featureList
            }
            .padding(.horizontal, theme.spacing.screenPadding)
            .padding(.vertical, theme.spacing.xxl)
        }
        .background(theme.colors.background.ignoresSafeArea())
        .navigationTitle("Phase 0")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Keihatsu")
                .font(theme.typography.hero)
                .foregroundStyle(theme.colors.textPrimary)

            Text("SwiftUI migration foundation with app-level routing, theme tokens, and feature placeholders.")
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textSecondary)
        }
    }

    private var architectureCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Architecture Boundaries")
                .font(theme.typography.sectionTitle)
                .foregroundStyle(theme.colors.textPrimary)

            Text("App owns startup and route coordination. DesignSystem owns shared tokens and primitives. Features own their root views without leaking data or platform plumbing into SwiftUI surfaces.")
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textSecondary)
        }
        .padding(theme.spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.large, style: .continuous))
        .shadow(color: theme.elevation.card.color, radius: theme.elevation.card.radius, y: theme.elevation.card.y)
        .overlay {
            RoundedRectangle(cornerRadius: theme.radius.large, style: .continuous)
                .stroke(theme.colors.border, lineWidth: 1)
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            Text("Feature Roots")
                .font(theme.typography.sectionTitle)
                .foregroundStyle(theme.colors.textPrimary)

            ForEach(FeatureDestination.allCases) { destination in
                Button {
                    withAnimation(theme.motion.navigationSpring) {
                        router.open(destination)
                    }
                } label: {
                    PlaceholderFeatureCard(destination: destination)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
