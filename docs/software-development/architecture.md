# System Architecture

## 1. Technical Overview

### Tech Stack

- Kotlin / Jetpack Compose
- AndroidX `ViewModel` + `StateFlow`
- OkHttp for API requests
- `androidx.media3` / ExoPlayer for direct stream playback
- `WebView` for embedded `iframe` sources
- Coil for remote images
- Local storage for liked movies and playback resume

### Architecture

The repo currently centers on a single native Android app in `android-compose`.

Feature flow:

`UI View -> ViewModel -> Repository -> ApiClient / Security / Storage`

### Player Architecture

- `GET /api/play/get` returns encrypted playback sources.
- The client decrypts the payload and maps it into `PlaySource` / `PlayTrack`.
- `playableSources()` only keeps `isFrame=false` sources for the native rail.
- Native playback uses Media3 / ExoPlayer for direct streams.
- `isFrame=true` sources are rendered through `WebView`.

### Track Semantics

- `Tracks.kind=audio` is treated as audio selection.
- `Tracks.kind=subtitle`, `sub`, `caption`, or `captions` is treated as subtitle selection.
- A `Subtitle` file field can be used as a fallback subtitle when no explicit subtitle track exists.
- Captions are not treated as audio dubbing.

### State Management Pattern

- Each screen has a dedicated `ViewModel`.
- Views observe state via `StateFlow`.
- Shared dependencies are provided through the app container.

### Verification

- Player behavior is covered by unit tests for model mapping and player presentation.
- Playback logs are used for source-selection and track-selection debugging.

## 2. Dependency Graph

- `app/` contains app bootstrap, navigation, and DI.
- `core/network/` wraps HTTP calls.
- `core/security/` decrypts encrypted payloads.
- `core/storage/` stores liked movies and playback position.
- `data/` contains mappers and repository implementations.
- `feature/player/` owns source selection, track selection, playback engine, and UI.
