package com.motchill.androidcompose.feature.search

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.lifecycle.viewmodel.compose.viewModel
import com.motchill.androidcompose.app.di.PhucTVAppContainer

@Composable
fun SearchRoute(
    initialQuery: String,
    presetSlug: String,
    initialLabel: String,
    startLikedOnly: Boolean,
    onBack: () -> Unit,
    onOpenDetail: (String) -> Unit,
) {
    val searchViewModel: SearchViewModel = viewModel(
        factory = remember(initialQuery, presetSlug, initialLabel, startLikedOnly) {
            SearchViewModel.factory(
                repository = PhucTVAppContainer.repository,
                likedMovieStore = PhucTVAppContainer.likedMovieStore,
                initialQuery = initialQuery,
                initialSlug = presetSlug,
                initialLabel = initialLabel,
                startLikedOnly = startLikedOnly,
            )
        },
    )
    val uiState by searchViewModel.uiState.collectAsState()

    SearchScreen(
        uiState = uiState,
        onBack = onBack,
        onOpenDetail = onOpenDetail,
        onRetry = searchViewModel::refresh,
        onSearchTextChanged = searchViewModel::onSearchTextChanged,
        onSubmitSearch = searchViewModel::submitSearch,
        onSelectCategory = searchViewModel::selectCategory,
        onSelectCountry = searchViewModel::selectCountry,
        onSelectTypeRaw = searchViewModel::selectTypeRaw,
        onSelectYear = searchViewModel::selectYear,
        onSelectOrderBy = searchViewModel::selectOrderBy,
        onToggleLikedOnly = searchViewModel::toggleLikedOnly,
        onClearSearch = searchViewModel::clearSearch,
        onClearCategory = searchViewModel::clearCategory,
        onClearCountry = searchViewModel::clearCountry,
        onClearTypeRaw = searchViewModel::clearTypeRaw,
        onClearYear = searchViewModel::clearYear,
        onClearOrderBy = searchViewModel::clearOrderBy,
        onGoToPage = searchViewModel::goToPage,
    )
}
