package com.motchill.androidcompose.core.supabase.models

import com.motchill.androidcompose.domain.model.MovieCard
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class LikedMovieRow(
    @SerialName("user_id") val userId: String,
    @SerialName("movie_id") val movieId: Int,
    @SerialName("movie_snapshot") val movieSnapshot: MovieCard,
    @SerialName("created_at") val createdAt: String? = null,
)
