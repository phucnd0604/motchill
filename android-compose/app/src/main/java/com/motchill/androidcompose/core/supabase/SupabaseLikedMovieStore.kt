package com.motchill.androidcompose.core.supabase

import com.motchill.androidcompose.domain.model.MovieCard

class SupabaseLikedMovieStore(
    private val client: SupabaseRestClient,
    private val authSessionProvider: AuthSessionProvider,
) : LikedMovieStore {
    override suspend fun loadMovies(): List<MovieCard> {
        val user = authSessionProvider.userId ?: return emptyList()
        return client.loadLikedMovies(user)
    }

    override suspend fun isLiked(movieId: Int): Boolean {
        val user = authSessionProvider.userId ?: return false
        // For now, we fetch all and check. 
        // In a real app, we might have a more optimized endpoint or a local cache.
        return client.loadLikedMovies(user).any { it.id == movieId }
    }

    override suspend fun toggleMovie(movie: MovieCard): List<MovieCard> {
        val user = authSessionProvider.userId ?: return emptyList()
        return client.toggleLikedMovie(user, movie)
    }
}
