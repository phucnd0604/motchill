package com.motchill.androidcompose.feature.home

import com.motchill.androidcompose.domain.model.HomeSection
import com.motchill.androidcompose.domain.model.MovieCard
import org.junit.Assert.assertEquals
import org.junit.Test

class HomePresentationTest {
    @Test
    fun `slide section prefers explicit slide key`() {
        val sections = listOf(
            section(key = "action", title = "Action"),
            section(key = "slide", title = "Hero"),
        )

        assertEquals("slide", slideSection(sections)?.key)
    }

    @Test
    fun `content sections keep slide key`() {
        val sections = listOf(
            section(key = "slide", title = "Hero"),
            section(key = "drama", title = "Drama"),
        )

        assertEquals(listOf("slide", "drama"), contentSections(sections).map { it.key })
    }

    @Test
    fun `section slug normalizes title when key is empty`() {
        val slug = sectionSearchSlug(
            section(key = "", title = "Coming Soon 2024"),
        )

        assertEquals("coming-soon-2024", slug)
    }

    @Test
    fun `home ui state derives movies from all sections`() {
        val firstMovie = movie(id = 1)
        val otherMovie = movie(id = 2)
        val state = HomeUiState(
            sections = listOf(
                section(key = "slide", title = "Hero", movies = listOf(firstMovie)),
                section(key = "drama", title = "Drama", movies = listOf(otherMovie)),
            ),
        )

        assertEquals(listOf(firstMovie, otherMovie), state.heroMovies)
        assertEquals(firstMovie, state.selectedMovie)
        assertEquals(listOf(otherMovie), state.previewMovies)
    }

    private fun section(
        key: String,
        title: String,
        movies: List<MovieCard> = emptyList(),
    ) = HomeSection(
        title = title,
        key = key,
        products = movies,
        isCarousel = false,
    )

    private fun movie(id: Int) = MovieCard(
        id = id,
        name = "Movie $id",
        otherName = "",
        avatar = "",
        bannerThumb = "",
        avatarThumb = "",
        description = "",
        banner = "",
        imageIcon = "",
        link = "movie-$id",
        quantity = "",
        rating = "",
        year = 2024,
        statusTitle = "",
    )
}
