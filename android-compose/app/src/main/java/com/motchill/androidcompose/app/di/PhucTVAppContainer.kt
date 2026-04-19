package com.motchill.androidcompose.app.di

import android.content.Context
import com.motchill.androidcompose.BuildConfig
import com.motchill.androidcompose.core.supabase.DefaultSyncCoordinator
import com.motchill.androidcompose.core.supabase.SupabaseAuthManager
import com.motchill.androidcompose.core.supabase.SupabaseConfig
import com.motchill.androidcompose.core.supabase.SupabaseLikedMovieStore
import com.motchill.androidcompose.core.supabase.SupabasePlaybackPositionStore
import com.motchill.androidcompose.core.supabase.SupabaseRestClient
import com.motchill.androidcompose.core.supabase.SupabaseSessionStore
import com.motchill.androidcompose.core.network.PhucTVApiClient
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

    val supabaseConfig: SupabaseConfig by lazy {
        SupabaseConfig(
            url = BuildConfig.SUPABASE_URL,
            publishableKey = BuildConfig.SUPABASE_ANON_KEY,
        )
    }

    val supabaseClient: io.github.jan.supabase.SupabaseClient by lazy {
        com.motchill.androidcompose.core.supabase.createSupabaseClient(supabaseConfig)
    }

    val supabaseRestClient: SupabaseRestClient by lazy {
        SupabaseRestClient(supabaseClient)
    }

    val authManager: SupabaseAuthManager by lazy {
        checkInitialized()
        SupabaseAuthManager(
            sessionStore = SupabaseSessionStore(appContext),
            networkClient = supabaseRestClient,
        )
    }

    val likedMovieStore: SupabaseLikedMovieStore by lazy {
        SupabaseLikedMovieStore(supabaseRestClient, authManager)
    }

    val playbackPositionStore: SupabasePlaybackPositionStore by lazy {
        SupabasePlaybackPositionStore(supabaseRestClient, authManager)
    }

    val repository: PhucTVRepository by lazy {
        DefaultPhucTVRepository(apiClient)
    }

    val syncCoordinator: DefaultSyncCoordinator by lazy {
        DefaultSyncCoordinator(
            remotePlaybackStore = playbackPositionStore,
        ).also { authManager.attachSyncCoordinator(it) }
    }

    private fun checkInitialized() {
        check(initialized) {
            "PhucTVAppContainer must be initialized before accessing storage."
        }
    }
}
