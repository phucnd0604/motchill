package com.motchill.androidcompose.feature.detail

import com.motchill.androidcompose.domain.model.MovieCard
import com.motchill.androidcompose.domain.model.MovieDetail
import com.motchill.androidcompose.domain.model.MovieEpisode
import com.motchill.androidcompose.domain.model.SimpleLabel

internal object DetailMockData {
    fun detail(): MovieDetail {
        val movie = MovieCard(
            id = 42,
            name = "Oppenheimer",
            otherName = "2023",
            avatar = "https://example.com/avatar.jpg",
            bannerThumb = "https://example.com/banner-thumb.jpg",
            avatarThumb = "https://example.com/avatar-thumb.jpg",
            description = "The story of J. Robert Oppenheimer and the Manhattan Project.",
            banner = "https://example.com/banner.jpg",
            imageIcon = "",
            link = "oppenheimer",
            quantity = "4K",
            rating = "8.6",
            year = 2023,
            statusTitle = "Completed",
            statusRaw = "completed",
            statusText = "Finished",
            director = "Christopher Nolan",
            time = "180m",
            trailer = "https://youtube.com/watch?v=example",
            showTimes = "Now showing",
            moreInfo = "Academy Award winner",
            castString = "Cillian Murphy, Emily Blunt",
            episodesTotal = 1,
            viewNumber = 1200000,
            ratePoint = 8.6,
            photoUrls = listOf("https://example.com/photo-1.jpg"),
            previewPhotoUrls = listOf("https://example.com/preview-1.jpg"),
        )

        return MovieDetail(
            movie = movie,
            relatedMovies = listOf(movie.copy(id = 43, name = "Tenet", link = "tenet", rating = "7.8")),
            countries = listOf(SimpleLabel(1, "United States", "us", 1)),
            categories = listOf(SimpleLabel(2, "Drama", "drama", 1)),
            episodes = listOf(
                MovieEpisode(
                    id = 1,
                    episodeNumber = 1,
                    name = "Episode 1",
                    fullLink = "https://example.com/play",
                    status = null,
                    type = "stream",
                ),
            ),
        )
    }
}

