import SwiftUI

struct PlayerView: View {
    @State private var viewModel = PlayerViewModel()

    var body: some View {
        FeaturePlaceholderView(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            bodyText: viewModel.bodyText,
            bullets: viewModel.bullets
        )
    }
}

#Preview("Player") {
    NavigationStack {
        PlayerView()
    }
}
