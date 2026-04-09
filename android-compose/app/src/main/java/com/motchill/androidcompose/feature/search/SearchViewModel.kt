package com.motchill.androidcompose.feature.search

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.motchill.androidcompose.core.storage.LikedMovieStore
import com.motchill.androidcompose.data.repository.MotchillRepository
import com.motchill.androidcompose.domain.model.SearchChoice
import com.motchill.androidcompose.domain.model.SearchFacetOption
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

internal class SearchViewModel(
    private val repository: MotchillRepository,
    private val likedMovieStore: LikedMovieStore,
    private val initialQuery: String,
    private val initialSlug: String,
    private val initialLabel: String,
    private val initialLikedOnly: Boolean,
) : ViewModel() {
    private val _uiState = MutableStateFlow(
        SearchUiState(
            searchText = initialQuery,
            searchInputValue = initialQuery,
            showLikedOnly = initialLikedOnly,
        ),
    )
    val uiState: StateFlow<SearchUiState> = _uiState.asStateFlow()

    init {
        load()
    }

    fun refresh() {
        loadPage(_uiState.value.pageNumber)
    }

    fun onSearchTextChanged(value: String) {
        _uiState.value = _uiState.value.withSearchInput(value)
    }

    fun submitSearch(value: String? = null) {
        val nextValue = (value ?: _uiState.value.searchInputValue).trim()
        _uiState.value = _uiState.value
            .withSearchInput(nextValue)
            .commitSearch()
        loadPage(1)
    }

    fun clearSearch() {
        _uiState.value = _uiState.value.clearSearchInput()
        loadPage(1)
    }

    fun selectCategory(option: SearchFacetOption?) {
        if (option == null || !option.hasId || option.id <= 0) {
            clearCategory()
            return
        }
        _uiState.value = _uiState.value.withCategory(option)
        loadPage(1)
    }

    fun selectCountry(option: SearchFacetOption?) {
        if (option == null || !option.hasId || option.id <= 0) {
            clearCountry()
            return
        }
        _uiState.value = _uiState.value.withCountry(option)
        loadPage(1)
    }

    fun selectTypeRaw(choice: SearchChoice?) {
        if (choice == null || choice.value.trim().isEmpty()) {
            clearTypeRaw()
            return
        }
        _uiState.value = _uiState.value.withTypeRaw(choice)
        loadPage(1)
    }

    fun selectYear(choice: SearchChoice?) {
        if (choice == null || choice.value.trim().isEmpty()) {
            clearYear()
            return
        }
        _uiState.value = _uiState.value.withYear(choice)
        loadPage(1)
    }

    fun selectOrderBy(value: String) {
        _uiState.value = _uiState.value.withOrderBy(value)
        loadPage(1)
    }

    fun toggleLikedOnly() {
        _uiState.value = _uiState.value.toggleLikedOnly()
        // Flutter keeps the local liked list as the source of truth and does not refetch here.
    }

    fun clearCategory() {
        _uiState.value = _uiState.value.clearCategory()
        loadPage(1)
    }

    fun clearCountry() {
        _uiState.value = _uiState.value.clearCountry()
        loadPage(1)
    }

    fun clearTypeRaw() {
        _uiState.value = _uiState.value.clearTypeRaw()
        loadPage(1)
    }

    fun clearYear() {
        _uiState.value = _uiState.value.clearYear()
        loadPage(1)
    }

    fun clearOrderBy() {
        _uiState.value = _uiState.value.clearOrderBy()
        loadPage(1)
    }

    fun goToPage(pageNumber: Int) {
        loadPage(pageNumber.coerceAtLeast(1))
    }

    fun clearFilters() {
        _uiState.value = _uiState.value.copy(
            selectedCategoryId = null,
            selectedCategoryLabel = "",
            selectedCountryId = null,
            selectedCountryLabel = "",
            selectedTypeRaw = "",
            selectedTypeLabel = "",
            selectedYear = "",
            selectedOrderBy = DEFAULT_ORDER_BY,
            pageNumber = 1,
        )
        loadPage(1)
    }

    private fun load() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.withLoading()
            runCatching {
                coroutineScope {
                    val filtersDeferred = async { repository.loadSearchFilters() }
                    val likedDeferred = async { likedMovieStore.loadMovies() }
                    val filters = filtersDeferred.await()
                    val likedMovies = likedDeferred.await()
                    val preset = filters.findPreset(initialSlug)
                    _uiState.value = _uiState.value
                        .withLoadedFilters(filters)
                        .withLikedMovies(likedMovies)
                        .applyPreset(
                            preset = preset,
                            fallbackLabel = initialLabel,
                            slug = initialSlug,
                        )
                    if (initialQuery.trim().isNotEmpty()) {
                        _uiState.value = _uiState.value
                            .withSearchInput(initialQuery)
                            .commitSearch()
                    }
                    loadPage(1)
                }
            }.onFailure { error ->
                _uiState.value = _uiState.value.withError(error.message ?: error::class.java.simpleName)
            }
        }
    }

    private fun loadPage(pageNumber: Int) {
        viewModelScope.launch {
            val state = _uiState.value.withLoading(isSearching = _uiState.value.records.isNotEmpty())
            _uiState.value = state

            runCatching {
                val results = repository.loadSearchResults(
                    categoryId = state.selectedCategoryId,
                    countryId = state.selectedCountryId,
                    typeRaw = state.selectedTypeRaw,
                    year = state.selectedYear,
                    orderBy = state.selectedOrderBy,
                    search = state.searchText,
                    pageNumber = pageNumber,
                )

                _uiState.value = state.withSearchResults(results, pageNumber)
            }.onFailure { error ->
                _uiState.value = _uiState.value.withError(error.message ?: error::class.java.simpleName)
            }
        }
    }

    companion object {
        fun factory(
            repository: MotchillRepository,
            likedMovieStore: LikedMovieStore,
            initialQuery: String,
            initialSlug: String,
            initialLabel: String,
            startLikedOnly: Boolean,
        ): ViewModelProvider.Factory {
            return object : ViewModelProvider.Factory {
                @Suppress("UNCHECKED_CAST")
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    if (modelClass.isAssignableFrom(SearchViewModel::class.java)) {
                        return SearchViewModel(
                            repository = repository,
                            likedMovieStore = likedMovieStore,
                            initialQuery = initialQuery,
                            initialSlug = initialSlug,
                            initialLabel = initialLabel,
                            initialLikedOnly = startLikedOnly,
                        ) as T
                    }
                    throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
                }
            }
        }
    }
}
