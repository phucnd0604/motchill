import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
    enum CancelID {
        case load
    }

    struct LoadError: Equatable, Sendable, Error {
        let message: String

        init(_ error: Error) {
            message = String(describing: error)
        }
    }

    @ObservableState
    struct State: Equatable {
        var status: HomeScreenState = .loading
        var selectedSection: PhucTvHomeSection?
        var selectedMovie: PhucTvMovieCard?

        var loadedContent: HomeFeedContent? {
            if case let .loaded(content) = status {
                return content
            }
            return nil
        }

        var sections: [PhucTvHomeSection] {
            loadedContent?.sections ?? []
        }

        var heroSection: PhucTvHomeSection? {
            sections.first(where: { $0.key == "slide" }) ?? sections.first
        }

        var heroMovies: [PhucTvMovieCard] {
            Array(heroSection?.products.prefix(6) ?? [])
        }

        var contentSections: [PhucTvHomeSection] {
            guard sections.contains(where: { $0.key == "slide" }) else {
                return sections
            }

            return sections.filter { $0.key != "slide" }
        }

        var hasRenderableContent: Bool {
            sections.contains(where: { !$0.products.isEmpty })
        }

        static func previewLoaded() -> Self {
            var state = Self(
                status: .loaded(HomeFeedContent(sections: HomeMockData.loadedSections))
            )
            HomeFeature.reconcileSelection(&state, with: HomeMockData.loadedSections)
            return state
        }

        static func previewLoading() -> Self {
            Self(status: .loading)
        }

        static func previewEmpty() -> Self {
            Self(status: .empty)
        }

        static func previewError() -> Self {
            Self(status: .error(message: "Không thể tải nội dung ngay lúc này."))
        }
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onTask
        case retryTapped
        case loadResponse(Result<[PhucTvHomeSection], LoadError>)
        case searchTapped
        case detailTapped(movie: PhucTvMovieCard)
        case playerTapped
    }

    @Dependency(\.phucTvRepository) var repository
    @Dependency(\.phucTvRemoteConfigClient) var remoteConfigClient
    @Dependency(\.phucTvRemoteConfigStore) var remoteConfigStore

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onTask, .retryTapped:
                state.status = .loading
                return loadHome()

            case .binding(\.selectedSection):
                Self.applySectionSelection(&state, section: state.selectedSection)
                return .none

            case .binding(\.selectedMovie):
                Self.applyMovieSelection(&state, movie: state.selectedMovie)
                return .none

            case let .loadResponse(.success(sections)):
                if sections.isEmpty {
                    state.status = .empty
                    return .none
                }

                state.status = .loaded(HomeFeedContent(sections: sections))
                Self.reconcileSelection(&state, with: sections)
                return .none

            case let .loadResponse(.failure(error)):
                state.status = .error(message: error.message)
                return .none

            case .searchTapped, .detailTapped, .playerTapped:
                return .none

            case .binding:
                return .none
            }
        }
    }

    private func loadHome() -> Effect<Action> {
        let remoteConfigClient = remoteConfigClient
        let remoteConfigStore = remoteConfigStore
        let repository = repository

        return .run { send in
            do {
                let remoteConfig = try await remoteConfigClient.fetchRemoteConfig()
                remoteConfigStore.update(remoteConfig)

                let sections = try await repository.loadHome()
                await send(.loadResponse(.success(sections)))
            } catch is CancellationError {
                return
            } catch {
                PhucTvLogger.shared.error(
                    error,
                    message: "Home load failed",
                    metadata: [
                        "state": "home"
                    ]
                )
                await send(.loadResponse(.failure(.init(error))))
            }
        }
        .cancellable(id: CancelID.load, cancelInFlight: true)
    }

    private static func applySectionSelection(
        _ state: inout State,
        section: PhucTvHomeSection?
    ) {
        guard let section else {
            state.selectedSection = nil
            state.selectedMovie = nil
            return
        }

        let refreshedSection = state.sections.first(where: { $0.id == section.id }) ?? section
        state.selectedSection = refreshedSection
        applyMovieSelection(&state, movie: state.selectedMovie)
    }

    private static func applyMovieSelection(
        _ state: inout State,
        movie: PhucTvMovieCard?
    ) {
        guard let section = state.selectedSection else {
            state.selectedMovie = movie
            return
        }

        if let movie {
            state.selectedMovie = section.products.first(where: { $0.id == movie.id })
                ?? section.products.first
        } else {
            state.selectedMovie = section.products.first
        }
    }

    private static func reconcileSelection(
        _ state: inout State,
        with sections: [PhucTvHomeSection]
    ) {
        guard let selectedSection = state.selectedSection,
              let refreshedSection = sections.first(where: { $0.id == selectedSection.id }) else {
            state.selectedSection = sections.first
            state.selectedMovie = sections.first?.products.first
            return
        }

        state.selectedSection = refreshedSection

        if let selectedMovie = state.selectedMovie,
           let refreshedMovie = refreshedSection.products.first(where: { $0.id == selectedMovie.id }) {
            state.selectedMovie = refreshedMovie
        } else {
            state.selectedMovie = refreshedSection.products.first
        }
    }
}
