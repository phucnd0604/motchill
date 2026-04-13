package com.motchill.androidcompose.app.di

import android.content.Context
import com.motchill.androidcompose.core.network.PhucTVApiClient
import com.motchill.androidcompose.core.storage.LikedMovieStore
import com.motchill.androidcompose.core.storage.PlaybackPositionStore
import com.motchill.androidcompose.data.repository.DefaultPhucTVRepository
import com.motchill.androidcompose.data.repository.PhucTVRepository

object PhucTVAppContainer {
    private lateinit var appContext: Context
    private var initialized = false

    fun initialize(context: Context) {
        appContext = context.applicationContext
        initialized = true
    }

    val apiClient: PhucTVApiClient by lazy {
        PhucTVApiClient()
    }

    val repository: PhucTVRepository by lazy {
        DefaultPhucTVRepository(apiClient)
    }

    val likedMovieStore: LikedMovieStore by lazy {
        checkInitialized()
        LikedMovieStore(appContext)
    }

    val playbackPositionStore: PlaybackPositionStore by lazy {
        checkInitialized()
        PlaybackPositionStore(appContext)
    }

    private fun checkInitialized() {
        check(initialized) {
            "PhucTVAppContainer must be initialized before accessing storage."
        }
    }
}
