import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var hasLaunched = false
    }

    enum Action: Equatable {
        case task
    }

    @Dependency(\.phucTvRepository) private var repository
    @Dependency(\.phucTvLikedMovieStore) private var likedMovieStore
    @Dependency(\.phucTvPlaybackPositionStore) private var playbackPositionStore
    @Dependency(\.phucTvLocalPlaybackPositionStore) private var localPlaybackPositionStore
    @Dependency(\.phucTvRemoteConfigClient) private var remoteConfigClient
    @Dependency(\.phucTvRemoteConfigStore) private var remoteConfigStore
    @Dependency(\.phucTvAuthManager) private var authManager
    @Dependency(\.phucTvScreenIdleManager) private var screenIdleManager

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .task:
                state.hasLaunched = true
                _ = repository
                _ = likedMovieStore
                _ = playbackPositionStore
                _ = localPlaybackPositionStore
                _ = remoteConfigClient
                _ = remoteConfigStore
                _ = authManager
                _ = screenIdleManager
                return .none
            }
        }
    }
}
