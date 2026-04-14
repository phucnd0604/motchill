import Foundation

protocol PhucTvLegacyLocalDataMigrating: Sendable {
    func migrateIfNeeded() async
}

actor PhucTvLegacyLocalDataMigrator: PhucTvLegacyLocalDataMigrating {
    private let defaults: UserDefaults
    private let likedMovieStore: SupabaseLikedMovieStore
    private let playbackPositionStore: SupabasePlaybackPositionStore
    private var isRunning = false

    init(
        defaults: UserDefaults = .standard,
        likedMovieStore: SupabaseLikedMovieStore,
        playbackPositionStore: SupabasePlaybackPositionStore
    ) {
        self.defaults = defaults
        self.likedMovieStore = likedMovieStore
        self.playbackPositionStore = playbackPositionStore
    }

    func migrateIfNeeded() async {
        guard !isRunning else { return }
        isRunning = true
        defer { isRunning = false }

        do {
            let payload = try defaults.phucTvLoadLegacyDataPayload()
            guard !payload.isEmpty else { return }

            try await likedMovieStore.importLegacyMovies(payload.likedMovies)
            try await playbackPositionStore.importLegacyPositions(payload.playbackPositions)
            defaults.phucTvClearLegacyData()

            PhucTvLogger.shared.info(
                "Migrated legacy local data to Supabase and cleared local cache.",
                metadata: [
                    "liked_movies": "\(payload.likedMovies.count)",
                    "playback_positions": "\(payload.playbackPositions.count)"
                ]
            )
        } catch {
            PhucTvLogger.shared.warning(
                "Failed to migrate legacy local data to Supabase.",
                metadata: ["error": String(describing: error)]
            )
        }
    }
}
