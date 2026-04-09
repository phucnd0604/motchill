package com.motchill.androidcompose.feature.search

import com.motchill.androidcompose.domain.model.MovieCard
import com.motchill.androidcompose.domain.model.SearchFacetOption
import com.motchill.androidcompose.domain.model.SearchFilterData
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SearchPresentationTest {
    @Test
    fun `find preset prefers category before search text fallback`() {
        val filters = SearchFilterData(
            categories = listOf(SearchFacetOption(1, "Action", "hanh-dong")),
            countries = listOf(SearchFacetOption(2, "Korea", "han-quoc")),
        )

        val categoryPreset = filters.findPreset("hanh-dong")
        assertEquals(1, categoryPreset.categoryId)
        assertEquals("Action", categoryPreset.categoryLabel)
        assertTrue(categoryPreset.countryLabel.isNullOrBlank())

        val countryPreset = filters.findPreset("han-quoc")
        assertEquals(2, countryPreset.countryId)
        assertEquals("Korea", countryPreset.countryLabel)

        val fallback = SearchUiState().applyPreset(
            filters.findPreset("science-fiction"),
            fallbackLabel = "",
            slug = "science-fiction",
        )
        assertEquals("Science Fiction", fallback.selectedCategoryLabel)
    }

    @Test
    fun `liked-only filtering keeps local matches and paginates`() {
        val uiState = SearchUiState(searchText = "oppenheimer", selectedYear = "2023")
        val movies = listOf(
            movie(1, "Oppenheimer", year = 2023),
            movie(2, "Dune", year = 2024),
            movie(3, "Opp", year = 2023),
        )

        val filtered = filterLikedMovies(movies, uiState)
        assertEquals(listOf(1), filtered.map { it.id })

        val (page, pagination) = paginateMovies(filtered, pageNumber = 1, pageSize = 12)
        assertEquals(listOf(1), page.map { it.id })
        assertEquals(1, pagination.totalRecords)
        assertEquals(1, pagination.pageCount)
    }

    @Test
    fun `clear filters resets selection state`() {
        val state = SearchUiState(
            selectedCategoryId = 1,
            selectedCountryId = 2,
            selectedTypeRaw = "movie",
            selectedYear = "2023",
            selectedOrderBy = "Year",
            searchText = "oppenheimer",
            searchInputValue = "oppenheimer",
            showLikedOnly = true,
        )

        val cleared = state.clearSelectedFilters()
        assertEquals(null, cleared.selectedCategoryId)
        assertEquals(null, cleared.selectedCountryId)
        assertEquals("", cleared.selectedCategoryLabel)
        assertEquals("", cleared.selectedTypeRaw)
        assertEquals("", cleared.selectedTypeLabel)
        assertEquals("", cleared.selectedYear)
        assertEquals(DEFAULT_ORDER_BY, cleared.selectedOrderBy)
        assertTrue(!cleared.showLikedOnly)
        assertEquals("oppenheimer", cleared.searchText)
        assertEquals("oppenheimer", cleared.searchInputValue)
    }

    private fun movie(
        id: Int,
        name: String,
        year: Int,
    ) = MovieCard(
        id = id,
        name = name,
        otherName = "",
        avatar = "",
        bannerThumb = "",
        avatarThumb = "",
        description = "",
        banner = "",
        imageIcon = "",
        link = "movie-$id",
        quantity = "movie",
        rating = "",
        year = year,
        statusTitle = "",
    )
}
