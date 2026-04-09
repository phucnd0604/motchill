package com.motchill.androidcompose.domain.model

data class PlayTrack(
    val kind: String,
    val file: String,
    val label: String,
    val isDefault: Boolean,
) {
    val displayLabel: String
        get() {
            val trimmedLabel = label.trim()
            if (trimmedLabel.isNotEmpty()) return trimmedLabel
            val trimmedFile = file.trim()
            if (trimmedFile.isNotEmpty()) return trimmedFile
            val trimmedKind = kind.trim()
            return if (trimmedKind.isNotEmpty()) trimmedKind else "Track"
        }

    val isAudio: Boolean
        get() = matchesTrackKind(kind, AUDIO_KIND_HINTS)

    val isSubtitle: Boolean
        get() = matchesTrackKind(kind, SUBTITLE_KIND_HINTS) || looksLikeSubtitleFile(file)
}

data class PlaySource(
    val sourceId: Int,
    val serverName: String,
    val link: String,
    val subtitle: String,
    val type: Int,
    val isFrame: Boolean,
    val quality: String,
    val tracks: List<PlayTrack>,
) {
    val displayName: String
        get() = buildList {
            if (serverName.trim().isNotEmpty()) add(serverName.trim())
            if (quality.trim().isNotEmpty()) add(quality.trim())
            add(if (isFrame) "iframe" else "stream")
        }.joinToString(" • ")

    val audioTracks: List<PlayTrack>
        get() = tracks.filter { it.isAudio }

    val subtitleTracks: List<PlayTrack>
        get() = buildList {
            val explicitSubtitleTracks = tracks.filter { it.isSubtitle }
            addAll(explicitSubtitleTracks)
            if (explicitSubtitleTracks.isEmpty()) {
                subtitle.trim()
                    .takeIf { it.isNotEmpty() && looksLikeSubtitleFile(it) }
                    ?.let { subtitleUri ->
                        add(
                            PlayTrack(
                                kind = "subtitle",
                                file = subtitleUri,
                                label = "Subtitle",
                                isDefault = true,
                            ),
                        )
                    }
            }
        }

    val hasAudioTracks: Boolean
        get() = audioTracks.isNotEmpty()

    val hasSubtitleTracks: Boolean
        get() = subtitleTracks.isNotEmpty()

    val defaultAudioTrack: PlayTrack?
        get() = audioTracks.firstOrNull { it.isDefault }

    val defaultSubtitleTrack: PlayTrack?
        get() = subtitleTracks.firstOrNull { it.isDefault }

    val isStream: Boolean
        get() = !isFrame
}

private fun matchesTrackKind(kind: String, expected: String): Boolean {
    val normalizedKind = kind.trim().lowercase()
    val normalizedExpected = expected.trim().lowercase()
    return normalizedKind.contains(normalizedExpected)
}

private fun matchesTrackKind(kind: String, expectedHints: List<String>): Boolean {
    val normalizedKind = kind.trim().lowercase()
    if (normalizedKind.isEmpty()) return false
    return expectedHints.any { hint -> normalizedKind.contains(hint) }
}

private fun looksLikeSubtitleFile(file: String): Boolean {
    val extension = file.trim().substringAfterLast('.', "").lowercase()
    return extension in setOf("srt", "vtt", "ass", "ssa", "sub", "ttml", "dfxp")
}

private val AUDIO_KIND_HINTS = listOf(
    "audio",
    "dub",
    "voice",
    "aac",
    "mp4a",
)

private val SUBTITLE_KIND_HINTS = listOf(
    "subtitle",
    "sub",
    "caption",
    "captions",
    "cc",
    "text",
)

