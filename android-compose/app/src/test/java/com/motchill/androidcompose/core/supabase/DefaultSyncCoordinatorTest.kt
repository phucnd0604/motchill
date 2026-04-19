package com.motchill.androidcompose.core.supabase

import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class DefaultSyncCoordinatorTest {
    @Test
    fun `syncPlaybackProgress clamps negative values and delegates save`() = runTest {
        val store = FakePlaybackPositionStore()
        val coordinator = DefaultSyncCoordinator(
            remotePlaybackStore = store,
        )

        coordinator.syncPlaybackProgress(
            movieId = 12,
            episodeId = 5,
            posMs = -1_000L,
            durMs = -2_000L,
        )

        assertEquals(
            listOf(
                FakePlaybackPositionStore.SaveCall(
                    movieId = 12,
                    episodeId = 5,
                    positionMillis = 0L,
                    durationMillis = 0L,
                ),
            ),
            store.saveCalls,
        )
    }

    @Test
    fun `syncPlaybackProgress swallows store errors`() = runTest {
        val store = FakePlaybackPositionStore(shouldFail = true)
        val coordinator = DefaultSyncCoordinator(
            remotePlaybackStore = store,
        )

        coordinator.syncPlaybackProgress(
            movieId = 1,
            episodeId = 2,
            posMs = 10_000L,
            durMs = 20_000L,
        )

        assertTrue(store.saveCalls.isEmpty())
    }

    private class FakePlaybackPositionStore(
        private val shouldFail: Boolean = false,
    ) : PlaybackPositionStore {
        val saveCalls = mutableListOf<SaveCall>()

        override suspend fun load(movieId: Int, episodeId: Int): com.motchill.androidcompose.core.storage.PlaybackProgressSnapshot? {
            return null
        }

        override suspend fun save(movieId: Int, episodeId: Int, positionMillis: Long, durationMillis: Long) {
            if (shouldFail) error("boom")
            saveCalls += SaveCall(movieId, episodeId, positionMillis, durationMillis)
        }

        data class SaveCall(
            val movieId: Int,
            val episodeId: Int,
            val positionMillis: Long,
            val durationMillis: Long,
        )
    }
}
