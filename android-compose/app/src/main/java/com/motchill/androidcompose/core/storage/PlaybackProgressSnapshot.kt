package com.motchill.androidcompose.core.storage

data class PlaybackProgressSnapshot(
    val positionMillis: Long,
    val durationMillis: Long,
) {
    val progressFraction: Float
        get() = if (durationMillis > 0) {
            (positionMillis.toFloat() / durationMillis.toFloat()).coerceIn(0f, 1f)
        } else {
            0f
        }
}
