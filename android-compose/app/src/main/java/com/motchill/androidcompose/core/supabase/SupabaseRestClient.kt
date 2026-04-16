package com.motchill.androidcompose.core.supabase

import com.motchill.androidcompose.core.storage.PlaybackProgressSnapshot
import com.motchill.androidcompose.core.supabase.models.LikedMovieRow
import com.motchill.androidcompose.core.supabase.models.PlaybackPositionRow
import com.motchill.androidcompose.domain.model.MovieCard
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.auth.OtpType
import io.github.jan.supabase.auth.auth
import io.github.jan.supabase.auth.providers.builtin.OTP
import io.github.jan.supabase.auth.user.UserInfo
import io.github.jan.supabase.createSupabaseClient
import io.github.jan.supabase.postgrest.postgrest
import io.github.jan.supabase.postgrest.query.Columns
import io.github.jan.supabase.serializer.KotlinXSerializer
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json

class SupabaseRestClient(
    override val supabaseClient: SupabaseClient
) : SupabaseNetworkClient {
    private val client: SupabaseClient get() = supabaseClient

    fun isConfigured(): Boolean = true // Now managed via DI

    override suspend fun sendOtp(email: String) {
        client.auth.signInWith(OTP) {
            this.email = email.trim()
            createUser = true
        }
    }

    @OptIn(kotlin.time.ExperimentalTime::class)
    override suspend fun verifyOtp(email: String, token: String): SupabaseSession {
        client.auth.verifyEmailOtp(
            type = OtpType.Email.EMAIL,
            email = email.trim(),
            token = token.trim(),
        )
        val session = client.auth.currentSessionOrNull() ?: throw IllegalStateException("Verification failed")
        val user = client.auth.currentUserOrNull() ?: throw IllegalStateException("User not found")

        return session.toAppSession(user)
    }

    override suspend fun fetchCurrentUser(accessToken: String): UserSummary? {
        // SDK handles session management, we can just get current user if authenticated
        val user = client.auth.currentUserOrNull() ?: return null
        return user.toUserSummary()
    }

    suspend fun loadLikedMovies(userId: String): List<MovieCard> = withContext(Dispatchers.IO) {
        val response = client.postgrest["liked_movies"]
            .select {
                filter {
                    eq("user_id", userId)
                }
            }
        response.decodeList<LikedMovieRow>().map { it.movieSnapshot }
    }

    suspend fun toggleLikedMovie(userId: String, movie: MovieCard): List<MovieCard> = withContext(Dispatchers.IO) {
        val existing = client.postgrest["liked_movies"]
            .select {
                filter {
                    eq("user_id", userId)
                    eq("movie_id", movie.id)
                }
            }.decodeSingleOrNull<LikedMovieRow>()

        if (existing != null) {
            client.postgrest["liked_movies"].delete {
                filter {
                    eq("user_id", userId)
                    eq("movie_id", movie.id)
                }
            }
        } else {
            val row = LikedMovieRow(userId = userId, movieId = movie.id, movieSnapshot = movie)
            client.postgrest["liked_movies"].insert(row)
        }
        loadLikedMovies(userId)
    }

    suspend fun upsertLikedMovies(userId: String, movies: List<MovieCard>) = withContext(Dispatchers.IO) {
        if (movies.isEmpty()) return@withContext
        val rows = movies.map { LikedMovieRow(userId = userId, movieId = it.id, movieSnapshot = it) }
        client.postgrest["liked_movies"].upsert(rows) {
            onConflict = "user_id,movie_id"
        }
    }

    suspend fun loadPlaybackPosition(
        userId: String,
        movieId: Int,
        episodeId: Int,
    ): PlaybackProgressSnapshot? = withContext(Dispatchers.IO) {
        val row = client.postgrest["playback_positions"]
            .select {
                filter {
                    eq("user_id", userId)
                    eq("movie_id", movieId)
                    eq("episode_id", episodeId)
                }
            }.decodeSingleOrNull<PlaybackPositionRow>()
        
        row?.let { PlaybackProgressSnapshot(it.positionMillis, it.durationMillis) }
    }

    suspend fun upsertPlaybackPosition(row: PlaybackPositionRow) = withContext(Dispatchers.IO) {
        client.postgrest["playback_positions"].upsert(row) {
            onConflict = "user_id,movie_id,episode_id"
        }
    }

    suspend fun upsertPlaybackPositions(rows: List<PlaybackPositionRow>) = withContext(Dispatchers.IO) {
        if (rows.isEmpty()) return@withContext
        client.postgrest["playback_positions"].upsert(rows) {
            onConflict = "user_id,movie_id,episode_id"
        }
    }
}

    @OptIn(kotlin.time.ExperimentalTime::class)
    private fun io.github.jan.supabase.auth.user.UserSession.toAppSession(user: UserInfo): SupabaseSession {
        return SupabaseSession(
            accessToken = this.accessToken,
            refreshToken = this.refreshToken ?: "",
            tokenType = this.tokenType,
            expiresAtEpochSeconds = this.expiresAt.epochSeconds,
            user = user.toUserSummary(),
        )
    }

private fun UserInfo.toUserSummary(): UserSummary {
    return UserSummary(id = this.id, email = this.email)
}
