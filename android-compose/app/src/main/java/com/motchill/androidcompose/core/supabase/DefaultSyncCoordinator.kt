package com.motchill.androidcompose.core.supabase

class DefaultSyncCoordinator(
    private val remotePlaybackStore: PlaybackPositionStore,
) : SyncCoordinator {
    override suspend fun runMigrationIfNeeded() {
        // Local stores are removed, so migration is no longer needed
    }

    override suspend fun syncPlaybackProgress(movieId: Int, episodeId: Int, posMs: Long, durMs: Long) {
        runCatching {
            remotePlaybackStore.save(movieId, episodeId, posMs.coerceAtLeast(0L), durMs.coerceAtLeast(0L))
        }
    }
}
