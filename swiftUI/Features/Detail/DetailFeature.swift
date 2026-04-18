import ComposableArchitecture
import SwiftUI

@Reducer
struct DetailFeature {
    @ObservableState
    struct State: Equatable {
        var movie: PhucTvMovieCard

        init(movie: PhucTvMovieCard = .empty) {
            self.movie = movie
        }

        var movieTitle: String {
            movie.displayTitle
        }

        var movieSubtitle: String {
            movie.displaySubtitle
        }

        var summary: String {
            let candidates = [
                movie.description,
                movie.moreInfo,
                movie.displaySubtitle
            ]

            for candidate in candidates {
                let trimmed = candidate.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    return trimmed
                }
            }

            return "The existing detail view model will be mapped here in a later phase."
        }
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
