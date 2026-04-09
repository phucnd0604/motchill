package com.motchill.androidcompose.feature.home

import com.motchill.androidcompose.domain.model.HomeSection
import com.motchill.androidcompose.domain.model.MovieCard

internal object HomeMockData {
    fun homeLoadedState(): HomeUiState {
        val hero = movie(id = 1, name = "Dune: Part Two", otherName = "2024", rating = "8.8")
        val hero2 = movie(id = 2, name = "Oppenheimer", otherName = "2023", rating = "8.6")
        val sectionA = HomeSection(
            title = "Popular",
            key = "popular",
            products = listOf(hero, hero2),
            isCarousel = true,
        )
        val sectionB = HomeSection(
            title = "Trending Now",
            key = "trending",
            products = listOf(
                movie(id = 3, name = "Alien", otherName = "Sci-Fi"),
                movie(id = 4, name = "The Batman", otherName = "Action"),
            ),
            isCarousel = false,
        )
        return HomeUiState(
            isLoading = false,
            sections = listOf(sectionA, sectionB),
            selectedHeroIndex = 0,
        )
    }

    private fun movie(
        id: Int,
        name: String,
        otherName: String,
        rating: String = "",
    ): MovieCard = MovieCard(
        id = id,
        name = name,
        otherName = otherName,
        avatar = "",
        bannerThumb = "",
        avatarThumb = "",
        description = "",
        banner = "",
        imageIcon = "",
        link = "movie-$id",
        quantity = "",
        rating = rating,
        year = 2024,
        statusTitle = "",
    )
}
