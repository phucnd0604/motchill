package com.motchill.androidcompose.feature.search

import com.motchill.androidcompose.domain.model.MovieCard
import com.motchill.androidcompose.domain.model.SearchChoice
import com.motchill.androidcompose.domain.model.SearchFacetOption
import com.motchill.androidcompose.domain.model.SearchFilterData
import com.motchill.androidcompose.domain.model.SearchPagination
import com.motchill.androidcompose.domain.model.SearchResults

internal const val SEARCH_PAGE_SIZE = 12
internal const val DEFAULT_ORDER_BY = "UpdateOn"

internal val searchOrderOptions = listOf(
    SearchChoice(value = "UpdateOn", label = "Mới Nhất"),
    SearchChoice(value = "ViewNumber", label = "Lượt Xem"),
    SearchChoice(value = "Year", label = "Năm Phát Hành"),
)

internal val searchTypeOptions = listOf(
    SearchChoice(value = "", label = "Tất cả"),
    SearchChoice(value = "single", label = "Phim Lẻ"),
    SearchChoice(value = "series", label = "Phim Bộ"),
)

internal val searchYearOptions = listOf(
    SearchChoice(value = "", label = "Tất cả"),
    SearchChoice(value = "2025", label = "2025"),
    SearchChoice(value = "2024", label = "2024"),
    SearchChoice(value = "2023", label = "2023"),
    SearchChoice(value = "2022", label = "2022"),
    SearchChoice(value = "2021", label = "2021"),
    SearchChoice(value = "2020", label = "2020"),
    SearchChoice(value = "2019", label = "2019"),
    SearchChoice(value = "2018", label = "2018"),
    SearchChoice(value = "2017", label = "2017"),
    SearchChoice(value = "2016", label = "2016"),
    SearchChoice(value = "2015", label = "2015"),
    SearchChoice(value = "2014", label = "2014"),
    SearchChoice(value = "2013", label = "2013"),
    SearchChoice(value = "2012", label = "2012"),
    SearchChoice(value = "2011", label = "2011"),
    SearchChoice(value = "2010", label = "2010"),
)

data class SearchPreset(
    val categoryId: Int? = null,
    val categoryLabel: String? = null,
    val countryId: Int? = null,
    val countryLabel: String? = null,
)

data class SearchUiState(
    val isLoading: Boolean = true,
    val isSearching: Boolean = false,
    val errorMessage: String? = null,
    val filters: SearchFilterData = SearchFilterData(emptyList(), emptyList()),
    val searchText: String = "",
    val searchInputValue: String = "",
    val selectedCategoryId: Int? = null,
    val selectedCategoryLabel: String = "",
    val selectedCountryId: Int? = null,
    val selectedCountryLabel: String = "",
    val selectedTypeRaw: String = "",
    val selectedTypeLabel: String = "",
    val selectedYear: String = "",
    val selectedOrderBy: String = DEFAULT_ORDER_BY,
    val showLikedOnly: Boolean = false,
    val likedMovies: List<MovieCard> = emptyList(),
    val likedMovieIds: Set<Int> = emptySet(),
    val records: List<MovieCard> = emptyList(),
    val pagination: SearchPagination = SearchPagination(0, 0, 0, 0),
    val pageNumber: Int = 1,
) {
    val visibleMovies: List<MovieCard>
        get() = if (showLikedOnly) {
            val query = searchText.trim().lowercase()
            likedMovies.filter { movie ->
                query.isEmpty() || listOf(
                    movie.displayTitle,
                    movie.displaySubtitle,
                    movie.description,
                    movie.statusTitle,
                    movie.link,
                ).any { it.lowercase().contains(query) }
            }
        } else {
            records
        }

    val currentPage: Int
        get() = pagination.pageIndex.takeIf { it > 0 } ?: pageNumber

    val totalPages: Int
        get() = pagination.pageCount

    val canGoPrevious: Boolean
        get() = currentPage > 1

    val canGoNext: Boolean
        get() = totalPages > 0 && currentPage < totalPages

    val currentOrderLabel: String
        get() = orderLabel(selectedOrderBy)

    val screenTitle: String
        get() = "Tìm kiếm phim"

    val screenSubtitle: String
        get() {
            val parts = buildList {
                val keyword = searchText.trim()
                if (keyword.isNotEmpty()) add('"' + keyword + '"')
                selectedCategoryLabel.trim().takeIf { it.isNotEmpty() }?.let { add(it) }
                selectedCountryLabel.trim().takeIf { it.isNotEmpty() }?.let { add(it) }
                selectedTypeLabel.trim().takeIf { it.isNotEmpty() }?.let { add(it) }
                selectedYear.trim().takeIf { it.isNotEmpty() }?.let { add(it) }
                if (showLikedOnly) add("Đã thích")
            }

            if (parts.isEmpty()) {
                return if (selectedCategoryLabel.trim().isNotEmpty()) {
                    "Lọc theo danh mục và từ khóa"
                } else {
                    "Nhập từ khóa hoặc chọn bộ lọc"
                }
            }

            return parts.joinToString(" • ")
        }

    val resultLabel: String
        get() = if (visibleMovies.isNotEmpty()) {
            "${visibleMovies.size} kết quả"
        } else {
            "Không có kết quả"
        }
}

internal fun SearchFilterData.findPreset(slug: String): SearchPreset {
    val normalizedSlug = slug.trim().lowercase()
    if (normalizedSlug.isEmpty()) return SearchPreset()

    categories.firstOrNull { matchesSlug(it, normalizedSlug) }?.let { category ->
        return SearchPreset(categoryId = category.id.takeIf { it > 0 }, categoryLabel = category.name)
    }
    countries.firstOrNull { matchesSlug(it, normalizedSlug) }?.let { country ->
        return SearchPreset(countryId = country.id.takeIf { it > 0 }, countryLabel = country.name)
    }
    return SearchPreset()
}

internal fun SearchFilterData.categoryOptionsWithAll(): List<SearchFacetOption> {
    return withAllItem(categories)
}

internal fun SearchFilterData.countryOptionsWithAll(): List<SearchFacetOption> {
    return withAllItem(countries)
}

internal fun SearchUiState.applyPreset(
    preset: SearchPreset,
    fallbackLabel: String = "",
    slug: String = "",
): SearchUiState {
    val fallback = fallbackLabel.trim().ifEmpty { humanizeSlug(slug) }
    return copy(
        selectedCategoryId = preset.categoryId,
        selectedCategoryLabel = preset.categoryLabel.orEmpty().ifEmpty { fallback },
        selectedCountryId = preset.countryId,
        selectedCountryLabel = preset.countryLabel.orEmpty(),
        pageNumber = 1,
    )
}

internal fun SearchUiState.withSearchInput(text: String): SearchUiState {
    return copy(searchInputValue = text)
}

internal fun SearchUiState.commitSearch(): SearchUiState {
    return copy(searchText = searchInputValue.trim(), pageNumber = 1)
}

internal fun SearchUiState.withCategory(option: SearchFacetOption?): SearchUiState {
    return copy(
        selectedCategoryId = option?.id?.takeIf { it > 0 },
        selectedCategoryLabel = option?.name.orEmpty(),
        pageNumber = 1,
    )
}

internal fun SearchUiState.withCountry(option: SearchFacetOption?): SearchUiState {
    return copy(
        selectedCountryId = option?.id?.takeIf { it > 0 },
        selectedCountryLabel = option?.name.orEmpty(),
        pageNumber = 1,
    )
}

internal fun SearchUiState.withTypeRaw(option: SearchChoice?): SearchUiState {
    return copy(
        selectedTypeRaw = option?.value.orEmpty().trim(),
        selectedTypeLabel = option?.label.orEmpty(),
        pageNumber = 1,
    )
}

internal fun SearchUiState.withYear(option: SearchChoice?): SearchUiState {
    return copy(
        selectedYear = option?.value.orEmpty().trim(),
        pageNumber = 1,
    )
}

internal fun SearchUiState.withOrderBy(value: String): SearchUiState {
    return copy(selectedOrderBy = value, pageNumber = 1)
}

internal fun SearchUiState.toggleLikedOnly(): SearchUiState {
    return copy(showLikedOnly = !showLikedOnly)
}

internal fun SearchUiState.clearSearchInput(): SearchUiState {
    return copy(searchInputValue = "", searchText = "", pageNumber = 1)
}

internal fun SearchUiState.clearCategory(): SearchUiState {
    return copy(selectedCategoryId = null, selectedCategoryLabel = "", pageNumber = 1)
}

internal fun SearchUiState.clearCountry(): SearchUiState {
    return copy(selectedCountryId = null, selectedCountryLabel = "", pageNumber = 1)
}

internal fun SearchUiState.clearTypeRaw(): SearchUiState {
    return copy(selectedTypeRaw = "", selectedTypeLabel = "", pageNumber = 1)
}

internal fun SearchUiState.clearYear(): SearchUiState {
    return copy(selectedYear = "", pageNumber = 1)
}

internal fun SearchUiState.clearOrderBy(): SearchUiState {
    return copy(selectedOrderBy = DEFAULT_ORDER_BY, pageNumber = 1)
}

internal fun SearchUiState.clearSelectedFilters(): SearchUiState {
    return copy(
        selectedCategoryId = null,
        selectedCategoryLabel = "",
        selectedCountryId = null,
        selectedCountryLabel = "",
        selectedTypeRaw = "",
        selectedTypeLabel = "",
        selectedYear = "",
        selectedOrderBy = DEFAULT_ORDER_BY,
        showLikedOnly = false,
        pageNumber = 1,
    )
}

internal fun SearchUiState.withLoadedFilters(filters: SearchFilterData): SearchUiState {
    return copy(filters = filters)
}

internal fun SearchUiState.withLikedMovies(movies: List<MovieCard>): SearchUiState {
    return copy(
        likedMovies = movies,
        likedMovieIds = movies.map { it.id }.toSet(),
    )
}

internal fun SearchUiState.withSearchResults(results: SearchResults, pageNumber: Int): SearchUiState {
    return copy(
        isLoading = false,
        isSearching = false,
        errorMessage = null,
        records = results.records,
        pagination = results.pagination,
        pageNumber = pageNumber,
    )
}

internal fun SearchUiState.withLoading(isSearching: Boolean = false): SearchUiState {
    return copy(
        isLoading = true,
        isSearching = isSearching,
        errorMessage = null,
    )
}

internal fun SearchUiState.withIdle(): SearchUiState {
    return copy(isLoading = false, isSearching = false)
}

internal fun SearchUiState.withError(message: String): SearchUiState {
    return copy(
        isLoading = false,
        isSearching = false,
        errorMessage = message,
    )
}

internal fun filterLikedMovies(movies: List<MovieCard>, uiState: SearchUiState): List<MovieCard> {
    val query = uiState.searchText.trim().lowercase()
    if (query.isEmpty()) return movies
    return movies.filter { movie ->
        listOf(
            movie.displayTitle,
            movie.displaySubtitle,
            movie.description,
            movie.statusTitle,
            movie.link,
        ).any { it.lowercase().contains(query) }
    }
}

internal fun paginateMovies(
    movies: List<MovieCard>,
    pageNumber: Int,
    pageSize: Int = SEARCH_PAGE_SIZE,
): Pair<List<MovieCard>, SearchPagination> {
    if (movies.isEmpty()) {
        return emptyList<MovieCard>() to SearchPagination(0, pageSize, 0, 0)
    }
    val safeSize = pageSize.coerceAtLeast(1)
    val pageCount = ((movies.size + safeSize - 1) / safeSize).coerceAtLeast(1)
    val safePage = pageNumber.coerceIn(1, pageCount)
    val start = (safePage - 1) * safeSize
    val end = (start + safeSize).coerceAtMost(movies.size)
    return movies.subList(start, end) to SearchPagination(
        pageIndex = safePage,
        pageSize = safeSize,
        pageCount = pageCount,
        totalRecords = movies.size,
    )
}

private fun withAllItem(items: List<SearchFacetOption>): List<SearchFacetOption> {
    if (items.isEmpty()) {
        return listOf(SearchFacetOption(id = 0, name = "Tất cả", slug = ""))
    }
    if (items.first().id == 0 && items.first().name.trim().equals("Tất cả", ignoreCase = true)) {
        return items
    }
    return listOf(SearchFacetOption(id = 0, name = "Tất cả", slug = "")) + items
}

private fun matchesSlug(option: SearchFacetOption, slug: String): Boolean {
    return listOf(option.name, option.slug)
        .map { it.trim().lowercase() }
        .filter { it.isNotEmpty() }
        .any { normalizeSlug(it) == slug }
}

private fun normalizeSlug(value: String): String {
    return value
        .replace(Regex("[^a-z0-9]+"), "-")
        .replace(Regex("-+"), "-")
        .trim('-')
}

private fun humanizeSlug(value: String): String {
    return value
        .split('-')
        .filter { it.isNotEmpty() }
        .joinToString(" ") { part ->
            if (part.length == 1) part.uppercase() else part.replaceFirstChar { it.uppercase() }
        }
}

private fun orderLabel(value: String): String {
    return when (value) {
        "ViewNumber" -> "Lượt Xem"
        "Year" -> "Năm Phát Hành"
        "Name" -> "Tên"
        else -> "Cập nhật mới"
    }
}
