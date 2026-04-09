package com.motchill.androidcompose.core.storage

import org.junit.Assert.assertEquals
import org.junit.Test

class PlaybackProgressSnapshotTest {
    @Test
    fun `progress fraction is clamped to zero when duration is missing`() {
        val snapshot = PlaybackProgressSnapshot(positionMillis = 15_000, durationMillis = 0)

        assertEquals(0f, snapshot.progressFraction, 0f)
    }

    @Test
    fun `progress fraction is computed from position and duration`() {
        val snapshot = PlaybackProgressSnapshot(positionMillis = 30_000, durationMillis = 120_000)

        assertEquals(0.25f, snapshot.progressFraction, 0.0001f)
    }

    @Test
    fun `progress fraction is clamped to one when position exceeds duration`() {
        val snapshot = PlaybackProgressSnapshot(positionMillis = 180_000, durationMillis = 120_000)

        assertEquals(1f, snapshot.progressFraction, 0f)
    }
}
