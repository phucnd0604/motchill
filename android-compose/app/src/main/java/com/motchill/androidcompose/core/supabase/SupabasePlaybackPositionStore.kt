package com.motchill.androidcompose.core.supabase

import com.motchill.androidcompose.core.storage.PlaybackProgressSnapshot
import com.motchill.androidcompose.core.supabase.models.PlaybackPositionRow

class SupabasePlaybackPositionStore(
    private val client: SupabaseRestClient,
    private val authSessionProvider: AuthSessionProvider,
) : PlaybackPositionStore {
    override suspend fun load(movieId: Int, episodeId: Int): PlaybackProgressSnapshot? {
        val user = authSessionProvider.userId ?: return null
        return client.loadPlaybackPosition(user, movieId, episodeId)
    }

    override suspend fun save(
        movieId: Int,
        episodeId: Int,
        positionMillis: Long,
        durationMillis: Long,
    ) {
        val user = authSessionProvider.userId ?: return
        client.upsertPlaybackPosition(
            row = PlaybackPositionRow(
                userId = user,
                movieId = movieId,
                episodeId = episodeId,
                positionMillis = positionMillis.coerceAtLeast(0L),
                durationMillis = durationMillis.coerceAtLeast(0L),
            ),
        )
    }
}
