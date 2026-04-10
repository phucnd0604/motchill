import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    let onTapSearch: () -> Void
    let onOpenDetail: () -> Void
    private let shouldLoadOnAppear: Bool

    init(
        repository: MotchillRepository,
        onTapSearch: @escaping () -> Void = {},
        onOpenDetail: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: HomeViewModel(repository: repository))
        self.onTapSearch = onTapSearch
        self.onOpenDetail = onOpenDetail
        self.shouldLoadOnAppear = true
    }

    init(
        viewModel: HomeViewModel,
        onTapSearch: @escaping () -> Void = {},
        onOpenDetail: @escaping () -> Void = {}
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onTapSearch = onTapSearch
        self.onOpenDetail = onOpenDetail
        self.shouldLoadOnAppear = false
    }

    var body: some View {
        HomeScreen(
            viewModel: viewModel,
            onTapSearch: onTapSearch,
            onOpenDetail: onOpenDetail
        )
        .task {
            guard shouldLoadOnAppear else {
                return
            }

            await viewModel.load()
        }
    }
}
