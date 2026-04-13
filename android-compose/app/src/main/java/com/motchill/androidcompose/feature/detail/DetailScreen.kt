package com.motchill.androidcompose.feature.detail

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.DisposableEffect
import androidx.compose.ui.platform.LocalUriHandler
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.compose.LocalLifecycleOwner
import androidx.lifecycle.viewmodel.compose.viewModel
import com.motchill.androidcompose.app.di.PhucTVAppContainer

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
                repository = PhucTVAppContainer.repository,
                likedMovieStore = PhucTVAppContainer.likedMovieStore,
                playbackPositionStore = PhucTVAppContainer.playbackPositionStore,
                slug = slug,
            )
        },
    )
    val uiState by detailViewModel.uiState.collectAsState()
    val uriHandler = LocalUriHandler.current
    val lifecycleOwner = LocalLifecycleOwner.current

    DisposableEffect(lifecycleOwner, detailViewModel) {
        val observer = LifecycleEventObserver { _, event ->
            if (event == Lifecycle.Event.ON_RESUME) {
                detailViewModel.refreshEpisodeProgress()
            }
        }
        lifecycleOwner.lifecycle.addObserver(observer)
        onDispose {
            lifecycleOwner.lifecycle.removeObserver(observer)
        }
    }

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
