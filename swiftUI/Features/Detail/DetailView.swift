import SwiftUI

struct DetailView: View {
    @State private var viewModel = DetailViewModel()

    var body: some View {
        FeaturePlaceholderView(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            bodyText: viewModel.bodyText,
            bullets: viewModel.bullets
        )
    }
}

#Preview("Detail") {
    NavigationStack {
        DetailView()
    }
}
