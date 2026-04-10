import SwiftUI

struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        FeaturePlaceholderView(
            title: viewModel.title,
            subtitle: viewModel.subtitle,
            bodyText: viewModel.bodyText,
            bullets: viewModel.bullets
        )
    }
}

#Preview("Search") {
    NavigationStack {
        SearchView()
    }
}
