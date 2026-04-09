# Modules and Screens

## 1. Home

### Purpose

- Render home sections.
- Navigate to search, detail, and liked-only search.

### API Integration

- `GET /api/moviehomepage`
- `GET /api/ads/popup`

## 2. Search and Category

### Purpose

- Search movies and filter by category, country, type, year, and order.
- Reuse the same screen for category entry points.

### API Integration

- `GET /api/filter`
- `GET /api/search`

## 3. Detail

### Purpose

- Show movie metadata, episodes, trailer, gallery, and related movies.
- Launch the player for an episode.

### API Integration

- `GET /api/movie/:slug`

## 4. Player

### Purpose

- Play episode sources from `/api/play/get`.
- Keep playback position local.
- Expose audio and subtitle selection when the selected source provides them.

### State

- `PlayerUiState.sources`
- `PlayerUiState.selectedSourceIndex`
- `PlayerUiState.selectedAudioTrack`
- `PlayerUiState.selectedSubtitleTrack`
- `PlayerRuntimeState.positionMs`
- `PlayerRuntimeState.durationMs`
- `PlayerRuntimeState.isPlaying`
- `PlayerRuntimeState.isBuffering`

### Behavior

- `playableSources()` filters out `isFrame=true` sources.
- Native stream sources play through Media3 / ExoPlayer.
- `isFrame=true` sources use the embedded `WebView` path.
- Audio/subtitle menus are shown only when the selected source has matching tracks.
- `Tracks.kind=captions` is treated as subtitle data.
- Source selection reloads the player while preserving episode resume position.

### API Integration

- `GET /api/play/get?movieId=...&episodeId=...&server=...`

## 5. Core Shared Modules

### Network

- `MotchillApiClient` wraps HTTP requests and response retrieval.

### Security

- `MotchillPayloadCipher` decrypts encrypted payloads.
- `MotchillPlayCipher` decodes playback source lists.

### Storage

- `LikedMovieStore` stores liked movies.
- `PlaybackPositionStore` stores resume position per episode.

### Widgets

- Shared image and focus helpers used across feature screens.
