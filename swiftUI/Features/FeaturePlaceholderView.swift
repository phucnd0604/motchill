import SwiftUI

struct FeaturePlaceholderView: View {
    let title: String
    let subtitle: String
    let bodyText: String
    let bullets: [String]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                RemoteImageView(url: nil)
                    .frame(height: 180)

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(AppTheme.titleFont)
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(subtitle)
                        .font(AppTheme.sectionTitleFont)
                        .foregroundStyle(AppTheme.accent)
                    Text(bodyText)
                        .font(AppTheme.bodyFont)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(AppTheme.accent)
                                .frame(width: 8, height: 8)
                                .padding(.top, 7)
                            Text(bullet)
                                .font(AppTheme.bodyFont)
                                .foregroundStyle(AppTheme.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppTheme.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppTheme.borderSoft, lineWidth: 1)
                )
            }
            .padding(20)
        }
        .background(AppTheme.background.ignoresSafeArea())
    }
}

#Preview("Feature Placeholder") {
    NavigationStack {
        FeaturePlaceholderView(
            title: "Preview",
            subtitle: "Mock state",
            bodyText: "This is a placeholder preview used to verify shared empty-state layout.",
            bullets: [
                "Supports a focused preview-friendly layout.",
                "Keeps the phase 2 screens visible while UI work continues.",
            ]
        )
    }
}
