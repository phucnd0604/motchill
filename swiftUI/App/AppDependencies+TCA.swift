import ComposableArchitecture
import Foundation
import Supabase

private enum PhucTvLiveDependencyFactory {
    static let configuration = AppConfiguration()

    static let remoteConfigClient: PhucTvRemoteConfigLoading = PhucTvRemoteConfigClient()
    static let remoteConfigStore: PhucTvRemoteConfigStoring = PhucTvRemoteConfigStore.shared
    static let repository: PhucTvRepository = DefaultPhucTvRepository(
        apiClient: PhucTvAPIClient(configuration: configuration)
    )
    static let supabaseClient: SupabaseClient? = makeSupabaseClient()
    static let likedMovieStore: SupabaseLikedMovieStore = SupabaseLikedMovieStore(client: supabaseClient)
    static let playbackPositionStore: SupabasePlaybackPositionStore = SupabasePlaybackPositionStore(client: supabaseClient)
    static let localPlaybackPositionStore: PhucTvPlaybackPositionStoring = UserDefaultsPhucTvPlaybackPositionStore()
    static let legacyDataMigrator: PhucTvLegacyLocalDataMigrating = PhucTvLegacyLocalDataMigrator(
        likedMovieStore: likedMovieStore,
        playbackPositionStore: playbackPositionStore
    )
    static let authManager: PhucTvSupabaseAuthManager = PhucTvSupabaseAuthManager(
        client: supabaseClient,
        redirectURL: configuration.supabaseAuthRedirectURL,
        legacyDataMigrator: legacyDataMigrator
    )
    static let screenIdleManager: ScreenIdleManaging = LiveScreenIdleManager()

    private static func makeSupabaseClient() -> SupabaseClient? {
        guard let supabaseConfiguration = PhucTvSupabaseConfiguration(configuration: configuration) else {
            return nil
        }

        return SupabaseClient(
            supabaseURL: supabaseConfiguration.url,
            supabaseKey: supabaseConfiguration.publishableKey,
            options: SupabaseClientOptions(
                auth: .init(
                    redirectToURL: configuration.supabaseAuthRedirectURL,
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
}

extension DependencyValues {
    var phucTvRemoteConfigClient: PhucTvRemoteConfigLoading {
        get { self[PhucTvRemoteConfigClientKey.self] }
        set { self[PhucTvRemoteConfigClientKey.self] = newValue }
    }

    var phucTvRemoteConfigStore: PhucTvRemoteConfigStoring {
        get { self[PhucTvRemoteConfigStoreKey.self] }
        set { self[PhucTvRemoteConfigStoreKey.self] = newValue }
    }

    var phucTvRepository: PhucTvRepository {
        get { self[PhucTvRepositoryKey.self] }
        set { self[PhucTvRepositoryKey.self] = newValue }
    }

    var phucTvLikedMovieStore: PhucTvLikedMovieStoring {
        get { self[PhucTvLikedMovieStoreKey.self] }
        set { self[PhucTvLikedMovieStoreKey.self] = newValue }
    }

    var phucTvPlaybackPositionStore: PhucTvPlaybackPositionStoring {
        get { self[PhucTvPlaybackPositionStoreKey.self] }
        set { self[PhucTvPlaybackPositionStoreKey.self] = newValue }
    }

    var phucTvLocalPlaybackPositionStore: PhucTvPlaybackPositionStoring {
        get { self[PhucTvLocalPlaybackPositionStoreKey.self] }
        set { self[PhucTvLocalPlaybackPositionStoreKey.self] = newValue }
    }

    var phucTvAuthManager: PhucTvSupabaseAuthManager {
        get { self[PhucTvAuthManagerKey.self] }
        set { self[PhucTvAuthManagerKey.self] = newValue }
    }

    var phucTvScreenIdleManager: ScreenIdleManaging {
        get { self[PhucTvScreenIdleManagerKey.self] }
        set { self[PhucTvScreenIdleManagerKey.self] = newValue }
    }
}

private enum PhucTvRemoteConfigClientKey: DependencyKey {
    static let liveValue: PhucTvRemoteConfigLoading = PhucTvLiveDependencyFactory.remoteConfigClient
    static let previewValue: PhucTvRemoteConfigLoading = PhucTvRemoteConfigClient()
    static let testValue: PhucTvRemoteConfigLoading = PhucTvRemoteConfigClient()
}

private enum PhucTvRemoteConfigStoreKey: DependencyKey {
    static let liveValue: PhucTvRemoteConfigStoring = PhucTvLiveDependencyFactory.remoteConfigStore
    static let previewValue: PhucTvRemoteConfigStoring = PhucTvRemoteConfigStore.shared
    static let testValue: PhucTvRemoteConfigStoring = PhucTvRemoteConfigStore.shared
}

private enum PhucTvRepositoryKey: DependencyKey {
    static let liveValue: PhucTvRepository = PhucTvLiveDependencyFactory.repository
    static let previewValue: PhucTvRepository = AppDependencies.preview.repository
    static let testValue: PhucTvRepository = AppDependencies.preview.repository
}

private enum PhucTvLikedMovieStoreKey: DependencyKey {
    static let liveValue: PhucTvLikedMovieStoring = PhucTvLiveDependencyFactory.likedMovieStore
    static let previewValue: PhucTvLikedMovieStoring = AppDependencies.preview.likedMovieStore
    static let testValue: PhucTvLikedMovieStoring = AppDependencies.preview.likedMovieStore
}

private enum PhucTvPlaybackPositionStoreKey: DependencyKey {
    static let liveValue: PhucTvPlaybackPositionStoring = PhucTvLiveDependencyFactory.playbackPositionStore
    static let previewValue: PhucTvPlaybackPositionStoring = AppDependencies.preview.playbackPositionStore
    static let testValue: PhucTvPlaybackPositionStoring = AppDependencies.preview.playbackPositionStore
}

private enum PhucTvLocalPlaybackPositionStoreKey: DependencyKey {
    static let liveValue: PhucTvPlaybackPositionStoring = PhucTvLiveDependencyFactory.localPlaybackPositionStore
    static let previewValue: PhucTvPlaybackPositionStoring = AppDependencies.preview.localPlaybackPositionStore
    static let testValue: PhucTvPlaybackPositionStoring = AppDependencies.preview.localPlaybackPositionStore
}

private enum PhucTvAuthManagerKey: DependencyKey {
    static let liveValue: PhucTvSupabaseAuthManager = PhucTvLiveDependencyFactory.authManager
    static let previewValue: PhucTvSupabaseAuthManager = AppDependencies.preview.authManager
    static let testValue: PhucTvSupabaseAuthManager = AppDependencies.preview.authManager
}

private enum PhucTvScreenIdleManagerKey: DependencyKey {
    static let liveValue: ScreenIdleManaging = PhucTvLiveDependencyFactory.screenIdleManager
    static let previewValue: ScreenIdleManaging = AppDependencies.preview.screenIdleManager
    static let testValue: ScreenIdleManaging = AppDependencies.preview.screenIdleManager
}
