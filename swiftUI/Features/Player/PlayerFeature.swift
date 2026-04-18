import ComposableArchitecture
import SwiftUI

@Reducer
struct PlayerFeature {
    @ObservableState
    struct State: Equatable {
        var movieID: Int
        var episodeID: Int
        var movieTitle: String
        var episodeLabel: String
        var summary: String
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

struct PlayerFeatureView: View {
    @Bindable var store: StoreOf<PlayerFeature>

    var body: some View {
        PlaceholderFeatureScreen(
            title: store.movieTitle,
            subtitle: store.episodeLabel,
            description: store.summary,
            backTitle: "Quay lại",
            systemImage: "play.fill",
            onBack: { store.send(.backButtonTapped) }
        )
    }
}
