package com.motchill.androidcompose.feature.player

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.motchill.androidcompose.data.repository.PhucTVRepository
import com.motchill.androidcompose.domain.model.PlayTrack
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class PlayerViewModel(
    private val repository: PhucTVRepository,
    private val movieId: Int,
    private val episodeId: Int,
    movieTitle: String,
    episodeLabel: String,
) : ViewModel() {
    private val _uiState = MutableStateFlow(
        PlayerUiState.loading(movieId = movieId, episodeId = episodeId).copy(
            movieTitle = movieTitle,
            episodeLabel = episodeLabel,
        ),
    )
    val uiState: StateFlow<PlayerUiState> = _uiState.asStateFlow()

    init {
        load()
    }

    fun load() {
        Log.d(
            TAG,
            "load requested movieId=$movieId episodeId=$episodeId title=${_uiState.value.movieTitle} episode=${_uiState.value.episodeLabel}",
        )
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(
                isLoading = true,
                errorMessage = null,
            )

            runCatching {
                val sources = repository.loadEpisodeSources(movieId, episodeId)
                Log.d(TAG, "repository returned sources count=${sources.size}")
                val playable = playableSources(sources)
                Log.d(TAG, "playable sources count=${playable.size}")
                if (playable.isEmpty()) {
                    Log.d(TAG, "no playable stream source found movieId=$movieId episodeId=$episodeId")
                    _uiState.value = PlayerUiState(
                        movieId = movieId,
                        episodeId = episodeId,
                        movieTitle = _uiState.value.movieTitle,
                        episodeLabel = _uiState.value.episodeLabel,
                        isLoading = false,
                        errorMessage = "No source available, try again later",
                        sources = emptyList(),
                        selectedSourceIndex = 0,
                    )
                    return@runCatching
                }

                val firstSource = playable.first()
                val selection = defaultTrackSelection(firstSource)
                Log.d(
                    TAG,
                    buildString {
                        append("initial selection sourceId=")
                        append(firstSource.sourceId)
                        append(" server=")
                        append(firstSource.serverName)
                        append(" quality=")
                        append(firstSource.quality)
                        append(" audio=")
                        append(selection.audioTrack?.displayLabel.orEmpty())
                        append(" subtitle=")
                        append(selection.subtitleTrack?.displayLabel.orEmpty())
                    },
                )
                _uiState.value = PlayerUiState(
                    movieId = movieId,
                    episodeId = episodeId,
                    movieTitle = _uiState.value.movieTitle,
                    episodeLabel = _uiState.value.episodeLabel,
                    isLoading = false,
                    errorMessage = null,
                    sources = playable,
                    selectedSourceIndex = 0,
                    selectedAudioTrack = selection.audioTrack,
                    selectedSubtitleTrack = selection.subtitleTrack,
                )
            }.onFailure { error ->
                _uiState.value = _uiState.value.copy(
                    isLoading = false,
                    errorMessage = error.message ?: error::class.java.simpleName,
                )
            }
        }
    }

    fun selectSource(index: Int) {
        val sources = _uiState.value.playableSources
        if (index !in sources.indices) return

        val source = sources[index]
        val selection = defaultTrackSelection(source)
        Log.d(
            TAG,
            buildString {
                append("selectSource index=")
                append(index)
                append(" sourceId=")
                append(source.sourceId)
                append(" server=")
                append(source.serverName)
                append(" audio=")
                append(selection.audioTrack?.displayLabel.orEmpty())
                append(" subtitle=")
                append(selection.subtitleTrack?.displayLabel.orEmpty())
            },
        )
        _uiState.value = _uiState.value.copy(
            selectedSourceIndex = index,
            selectedAudioTrack = selection.audioTrack,
            selectedSubtitleTrack = selection.subtitleTrack,
        )
    }

    fun selectAudioTrack(track: PlayTrack?) {
        if (track != null && track !in selectedSourceTracks().audioTracks) return
        Log.d(TAG, "selectAudioTrack track=${track?.displayLabel.orEmpty()} file=${track?.file.orEmpty()}")
        _uiState.value = _uiState.value.copy(selectedAudioTrack = track)
    }

    fun selectSubtitleTrack(track: PlayTrack?) {
        if (track != null && track !in selectedSourceTracks().subtitleTracks) return
        Log.d(TAG, "selectSubtitleTrack track=${track?.displayLabel.orEmpty()} file=${track?.file.orEmpty()}")
        _uiState.value = _uiState.value.copy(selectedSubtitleTrack = track)
    }

    private fun selectedSourceTracks(): PlayerSourceTracks {
        val source = _uiState.value.selectedSource ?: return PlayerSourceTracks(
            audioTracks = emptyList(),
            subtitleTracks = emptyList(),
        )
        return PlayerSourceTracks(
            audioTracks = source.audioTracks,
            subtitleTracks = source.subtitleTracks,
        )
    }

    private data class PlayerSourceTracks(
        val audioTracks: List<PlayTrack>,
        val subtitleTracks: List<PlayTrack>,
    )

    companion object {
        fun factory(
            repository: PhucTVRepository,
            movieId: Int,
            episodeId: Int,
            movieTitle: String,
            episodeLabel: String,
        ): ViewModelProvider.Factory {
            return object : ViewModelProvider.Factory {
                @Suppress("UNCHECKED_CAST")
                override fun <T : ViewModel> create(modelClass: Class<T>): T {
                    if (modelClass.isAssignableFrom(PlayerViewModel::class.java)) {
                        return PlayerViewModel(
                            repository = repository,
                            movieId = movieId,
                            episodeId = episodeId,
                            movieTitle = movieTitle,
                            episodeLabel = episodeLabel,
                        ) as T
                    }
                    throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
                }
            }
        }

        private const val TAG = "PhucTV.player"
    }
}
