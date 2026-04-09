package com.motchill.androidcompose.feature.search

import com.motchill.androidcompose.domain.model.MovieCard
import com.motchill.androidcompose.domain.model.SearchFacetOption
import com.motchill.androidcompose.domain.model.SearchFilterData
import com.motchill.androidcompose.domain.model.SearchPagination

internal object SearchMockData {
    fun loadedState(): SearchUiState {
        val filters = SearchFilterData(
            categories = listOf(
                SearchFacetOption(1, "Action", "action"),
                SearchFacetOption(2, "Drama", "drama"),
            ),
            countries = listOf(
                SearchFacetOption(10, "United States", "united-states"),
                SearchFacetOption(11, "Korea", "korea"),
            ),
        )
        val records = listOf(
            movie(1, "Dune: Part Two", "2024", "8.8"),
            movie(2, "Oppenheimer", "2023", "8.6"),
            movie(3, "Tenet", "2020", "7.8"),
        )
        return SearchUiState(
            isLoading = false,
            filters = filters,
            searchText = "science fiction",
            searchInputValue = "science fiction",
            selectedCategoryId = null,
            selectedCategoryLabel = "Action",
            selectedCountryId = 10,
            selectedCountryLabel = "United States",
            selectedTypeRaw = "movie",
            selectedYear = "2024",
            selectedOrderBy = "ViewNumber",
            showLikedOnly = false,
            records = records,
            pagination = SearchPagination(pageIndex = 1, pageSize = 12, pageCount = 3, totalRecords = 32),
            pageNumber = 1,
        )
    }

    private fun movie(
        id: Int,
        name: String,
        otherName: String,
        rating: String,
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
        statusTitle = "Completed",
    )
}
