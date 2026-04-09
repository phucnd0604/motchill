package com.motchill.androidcompose.feature.detail

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalUriHandler
import androidx.lifecycle.viewmodel.compose.viewModel
import com.motchill.androidcompose.app.di.MotchillAppContainer

@Composable
fun DetailScreen(
    slug: String,
    onBack: () -> Unit,
    onOpenSearch: () -> Unit,
    onOpenDetail: (String) -> Unit,
    onOpenEpisode: (Int, Int, String, String) -> Unit,
) {
    val detailViewModel: DetailViewModel = viewModel(
        factory = remember(slug) {
            DetailViewModel.factory(
                repository = MotchillAppContainer.repository,
                likedMovieStore = MotchillAppContainer.likedMovieStore,
                slug = slug,
            )
        },
    )
    val uiState by detailViewModel.uiState.collectAsState()
    val uriHandler = LocalUriHandler.current

    DetailScreenContent(
        uiState = uiState,
        onBack = onBack,
        onOpenSearch = onOpenSearch,
        onOpenDetail = onOpenDetail,
        onOpenEpisode = onOpenEpisode,
        onRetry = detailViewModel::load,
        onSelectTab = detailViewModel::selectTab,
        onToggleLike = detailViewModel::toggleLike,
        onOpenTrailer = { url -> if (url.isNotBlank()) uriHandler.openUri(url) },
    )
}
