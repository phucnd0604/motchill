package com.motchill.androidcompose.core.storage

object PlaybackPositionKeys {
    fun key(movieId: Int, episodeId: Int): String {
        return "$PLAYBACK_POSITION_PREFIX:$movieId:$episodeId"
    }
}

object PlaybackDurationKeys {
    fun key(movieId: Int, episodeId: Int): String {
        return "$PLAYBACK_DURATION_PREFIX:$movieId:$episodeId"
    }
}

