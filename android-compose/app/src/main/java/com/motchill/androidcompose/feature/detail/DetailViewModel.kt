package com.motchill.androidcompose.feature.detail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.motchill.androidcompose.core.supabase.LikedMovieStore
import com.motchill.androidcompose.core.supabase.PlaybackPositionStore
import com.motchill.androidcompose.core.storage.PlaybackProgressSnapshot
import com.motchill.androidcompose.data.repository.PhucTVRepository
import com.motchill.androidcompose.domain.model.MovieCard
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class DetailViewModel(
    private val repository: PhucTVRepository,
    private val likedMovieStore: LikedMovieStore,
    private val playbackPositionStore: PlaybackPositionStore,
    private val slug: String,
) : ViewModel() {
    private val _uiState = MutableStateFlow(DetailUiState())
    val uiState: StateFlow<DetailUiState> = _uiState.asStateFlow()

    init {
        load()
    }

    fun load() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null,
            )
            runCatching {
                val detail = repository.loadDetail(slug)
                val liked = detail.id > 0 && runCatching {
                    likedMovieStore.isLiked(detail.id)
                }.getOrDefault(false)
                val episodeProgressById = runCatching {
                    loadEpisodeProgress(detail.id, detail.episodes)
                }.getOrDefault(emptyMap())
                _uiState.value = DetailUiState(
                    isLoading = false,
                    errorMessage = null,
                    detail = detail,
                    selectedTab = defaultDetailTab(detail),
                    isLiked = liked,
                    episodeProgressById = episodeProgressById,
                )
            }.onFailure { error ->
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = error.message ?: error::class.java.simpleName,
                )
            }
        }
    }

    fun selectTab(tab: DetailSectionTab) {
        _uiState.value = _uiState.value.copy(selectedTab = tab)
    }

    fun refreshEpisodeProgress() {
        val detail = _uiState.value.detail ?: return
        viewModelScope.launch {
            val episodeProgressById = loadEpisodeProgress(detail.id, detail.episodes)
            _uiState.value = _uiState.value.copy(episodeProgressById = episodeProgressById)
        }
    }

    fun refreshCloudState() {
        val detail = _uiState.value.detail ?: return
        if (detail.id == 0) return

        viewModelScope.launch {
            val currentState = _uiState.value
            val liked = runCatching {
                likedMovieStore.isLiked(detail.id)
            }.getOrNull()
            val episodeProgressById = runCatching {
                loadEpisodeProgress(detail.id, detail.episodes)
            }.getOrNull()

            if (liked == null && episodeProgressById == null) return@launch

            _uiState.value = _uiState.value.copy(
                isLiked = liked ?: currentState.isLiked,
                episodeProgressById = episodeProgressById ?: currentState.episodeProgressById,
            )
        }
    }

    fun toggleLike() {
        val detail = _uiState.value.detail ?: return
        if (detail.id == 0) return

        viewModelScope.launch {
            runCatching {
                likedMovieStore.toggleMovie(
                    MovieCard(
                        id = detail.id,
                        name = detail.title,
                        otherName = detail.otherName,
                        avatar = detail.avatar,
                        bannerThumb = detail.bannerThumb,
                        avatarThumb = detail.avatarThumb,
                        description = detail.description,
                        banner = detail.banner,
                        imageIcon = "",
                        link = detail.movie.link,
                        quantity = detail.quality,
                        rating = if (detail.ratePoint > 0) detail.ratePoint.toString() else "",
                        year = detail.year,
                        statusTitle = detail.statusTitle,
                        statusRaw = detail.statusRaw,
                        statusText = detail.statusText,
                        director = detail.director,
                        time = detail.time,
                        trailer = detail.trailer,
                        showTimes = detail.showTimes,
                        moreInfo = detail.moreInfo,
                        castString = detail.castString,
                        episodesTotal = detail.episodesTotal,
                        viewNumber = detail.viewNumber,
                        ratePoint = detail.ratePoint,
                        photoUrls = detail.photoUrls,
                        previewPhotoUrls = detail.previewPhotoUrls,
                    ),
                )
            }.onSuccess { updatedMovies ->
                _uiState.value = _uiState.value.copy(
                    isLiked = updatedMovies.any { it.id == detail.id },
                    errorMessage = null,
                )
            }.onFailure { error ->
                _uiState.value = _uiState.value.copy(
                    errorMessage = error.message ?: error::class.java.simpleName,
                )
            }
        }
    }

    private suspend fun loadEpisodeProgress(
        movieId: Int,
        episodes: List<com.motchill.androidcompose.domain.model.MovieEpisode>,
    ): Map<Int, PlaybackProgressSnapshot> {
        return buildMap {
            episodes.forEach { episode ->
                val snapshot = playbackPositionStore.load(movieId, episode.id) ?: return@forEach
                put(episode.id, snapshot)
            }
        }
    }

    companion object {
        fun factory(
            repository: PhucTVRepository,
            likedMovieStore: LikedMovieStore,
            playbackPositionStore: PlaybackPositionStore,
            slug: String,
        ): ViewModelProvider.Factory {
            return object : ViewModelProvider.Factory {
                @Suppress("UNCHECKED_CAST")
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    if (modelClass.isAssignableFrom(DetailViewModel::class.java)) {
                        return DetailViewModel(repository, likedMovieStore, playbackPositionStore, slug) as T
                    }
                    throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
                }
            }
        }
    }
}

