import ComposableArchitecture
import Foundation
import Testing

@testable import PhucTV

@MainActor
struct AppFeatureTests {
    init() {
        uncheckedUseMainSerialExecutor = true
    }

    @Test
    func launchSeedsAuthBanner() async {
        let authManager = PhucTvSupabaseAuthManager(client: nil)
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.configurePhucTvDependencies(AppDependencies.test(authManager: authManager))
        }

        #expect(store.state.home.status == .loading)
        #expect(store.state.path.isEmpty)

        await store.send(.task) {
            $0.authBanner = AppFeature.AuthBannerState(
                message: "Đăng nhập để đồng bộ liked movies và playback position.",
                buttonTitle: "Đăng nhập",
                isSignedIn: false
            )
        }
    }

    @Test
    func pushSearchRoute() async {
        let store = makeStore()

        await store.send(.home(.searchTapped)) {
            $0.path.append(.search(SearchFeature.State()))
        }
    }

    @Test
    func pushDetailFromSearchRoute() async {
        let store = makeStore()
        let movie = placeholderMovie()

        await store.send(.home(.searchTapped)) {
            $0.path.append(.search(SearchFeature.State()))
        }

        let id = store.state.path.ids.first!

        await store.send(.path(.element(id: id, action: .search(.detailTapped(movie: movie))))) {
            $0.path.append(.detail(DetailFeature.State(movie: movie)))
        }
    }

    @Test
    func pushDetailRoute() async {
        let store = makeStore()
        let movie = placeholderMovie()

        await store.send(.home(.detailTapped(movie: movie))) {
            $0.path.append(
                .detail(
                    DetailFeature.State(movie: movie)
                )
            )
        }

        guard case let .detail(detailState)? = store.state.path.first else {
            Issue.record("Expected a detail route to be pushed.")
            return
        }

        #expect(detailState.movie.id == movie.id)
    }

    @Test
    func pushPlayerRoute() async {
        let store = makeStore()
        let movie = placeholderMovie()

        await store.send(.home(.playerTapped)) {
            $0.path.append(
                .player(
                    PlayerFeature.State(
                        movieID: movie.id,
                        episodeID: 1,
                        movieTitle: movie.displayTitle,
                        episodeLabel: "Tập 1",
                        summary: "Placeholder player screen. Phase 3 will map playback logic here."
                    )
                )
            )
        }

        guard case let .player(playerState)? = store.state.path.first else {
            Issue.record("Expected a player route to be pushed.")
            return
        }

        #expect(playerState.movieTitle == movie.displayTitle)
    }

    @Test
    func popRouteFromChildBackAction() async {
        let store = makeStore()

        await store.send(.home(.searchTapped)) {
            $0.path.append(.search(SearchFeature.State()))
        }

        let id = store.state.path.ids.first!

        await store.send(.path(.element(id: id, action: .search(.backButtonTapped))))
        await store.receive(.popFromPath(id)) {
            $0.path = StackState()
        }
    }

    @Test
    func popToRootClearsStack() async {
        let store = makeStore()

        await store.send(.home(.searchTapped)) {
            $0.path.append(.search(SearchFeature.State()))
        }
        await store.send(.home(.detailTapped(movie: placeholderMovie()))) {
            $0.path.append(
                .detail(
                    DetailFeature.State(movie: placeholderMovie())
                )
            )
        }
        await store.send(.popToRootTapped) {
            $0.path = StackState()
        }
    }

    @Test
    func authBannerOpensAndDismissesSheet() async {
        let authManager = PhucTvSupabaseAuthManager(client: nil)
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.configurePhucTvDependencies(AppDependencies.test(authManager: authManager))
        }

        await store.send(.task) {
            $0.authBanner = AppFeature.AuthBannerState(
                message: "Đăng nhập để đồng bộ liked movies và playback position.",
                buttonTitle: "Đăng nhập",
                isSignedIn: false
            )
        }

        await store.send(.authBannerButtonTapped) {
            $0.auth = AuthFeature.State()
        }

        await store.send(.auth(.dismiss)) {
            $0.auth = nil
        }
    }

    @Test
    func openURLRefreshesAuthState() async {
        let authManager = PhucTvSupabaseAuthManager(client: nil)
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.configurePhucTvDependencies(AppDependencies.test(authManager: authManager))
        }

        await store.send(.task) {
            $0.authBanner = AppFeature.AuthBannerState(
                message: "Đăng nhập để đồng bộ liked movies và playback position.",
                buttonTitle: "Đăng nhập",
                isSignedIn: false
            )
        }

        await store.send(.openURL(URL(string: "phuctv://auth/callback")!))
        await store.receive(.authSnapshotRefreshed)
    }

    private func makeStore() -> TestStore<AppFeature.State, AppFeature.Action> {
        let authManager = PhucTvSupabaseAuthManager(client: nil)
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.configurePhucTvDependencies(AppDependencies.test(authManager: authManager))
        }

        return store
    }

    private func placeholderMovie() -> PhucTvMovieCard {
        PhucTvMovieCard(
            id: 1_001,
            name: "Placeholder Movie",
            otherName: "Shell Migration",
            avatar: "",
            bannerThumb: "",
            avatarThumb: "",
            description: "A placeholder movie used during the shell migration phase.",
            banner: "",
            imageIcon: "",
            link: "placeholder-movie",
            quantity: "",
            rating: "",
            year: 2026,
            statusTitle: "Placeholder",
            statusRaw: "placeholder",
            statusText: "placeholder",
            director: "",
            time: "",
            trailer: "",
            showTimes: "",
            moreInfo: "",
            castString: "",
            episodesTotal: 1,
            viewNumber: 0,
            ratePoint: 0,
            photoUrls: [],
            previewPhotoUrls: []
        )
    }

}
