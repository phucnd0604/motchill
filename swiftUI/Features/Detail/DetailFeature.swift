import ComposableArchitecture
import SwiftUI

@Reducer
struct DetailFeature {
    @ObservableState
    struct State: Equatable {
        var movieTitle = "Detail"
        var movieSubtitle = "Placeholder screen for phase 2"
        var summary = "The existing detail view model will be mapped here in a later phase."
    }

    @CasePathable
    enum Action: Equatable {
        case backButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

struct DetailFeatureView: View {
    @Bindable var store: StoreOf<DetailFeature>

    var body: some View {
        PlaceholderFeatureScreen(
            title: store.movieTitle,
            subtitle: store.movieSubtitle,
            description: store.summary,
            backTitle: "Quay lại",
            systemImage: "film",
            onBack: { store.send(.backButtonTapped) }
        )
    }
}
