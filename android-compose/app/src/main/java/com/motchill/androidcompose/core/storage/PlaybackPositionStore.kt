package com.motchill.androidcompose.core.storage

import android.content.Context
import androidx.core.content.edit
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

data class PlaybackProgressSnapshot(
    val positionMillis: Long,
    val durationMillis: Long,
) {
    val progressFraction: Float
        get() = if (durationMillis <= 0L) 0f else (positionMillis.toFloat() / durationMillis.toFloat()).coerceIn(0f, 1f)
}

class PlaybackPositionStore(context: Context) {
    private val prefs = context.getSharedPreferences(PLAYBACK_POSITION_PREFS, Context.MODE_PRIVATE)

    suspend fun save(
        movieId: Int,
        episodeId: Int,
        positionMillis: Long,
        durationMillis: Long,
    ) = withContext(Dispatchers.IO) {
        prefs.edit {
            putLong(PlaybackPositionKeys.key(movieId, episodeId), positionMillis)
            putLong(PlaybackDurationKeys.key(movieId, episodeId), durationMillis.coerceAtLeast(0L))
        }
    }

    suspend fun load(movieId: Int, episodeId: Int): PlaybackProgressSnapshot? = withContext(Dispatchers.IO) {
        val positionValue = prefs.getLong(PlaybackPositionKeys.key(movieId, episodeId), Long.MIN_VALUE)
        if (positionValue == Long.MIN_VALUE || positionValue < 0) return@withContext null

        val durationValue = prefs.getLong(PlaybackDurationKeys.key(movieId, episodeId), Long.MIN_VALUE)
        val durationMillis = if (durationValue == Long.MIN_VALUE || durationValue < 0) 0L else durationValue
        PlaybackProgressSnapshot(
            positionMillis = positionValue,
            durationMillis = durationMillis,
        )
    }
}

