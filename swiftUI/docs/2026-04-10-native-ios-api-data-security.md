# API, Data, and Security

## API Surface

The iOS app should start with the same public endpoints the Android app uses:

- `GET /api/moviehomepage`
- `GET /api/movie/:slug`
- `GET /api/movie/preview/:slug`
- `GET /api/navbar`
- `GET /api/ads/popup`
- `GET /api/filter`
- `GET /api/search`
- `GET /api/play/get?movieId=...&episodeId=...&server=...`

## Request Behavior

- Base URL comes from configuration, with `https://motchilltv.taxi` as the default.
- Requests should use a browser-like `User-Agent`.
- The client should keep request construction small and testable.

## Payload Contracts

The app currently treats search and playback responses as encrypted payloads that must be decoded before JSON parsing.

Important response behaviors:

- Search payloads may arrive as ciphertext instead of plain JSON.
- Playback payloads return the episode source list after decryption.
- The payload parser should fail clearly when the decrypted text is empty or malformed.

## Data Models

The iOS domain layer should preserve the same conceptual entities as Android:

- `HomeSection`
- `MovieCard`
- `NavbarItem`
- `PopupAdConfig`
- `MovieDetail`
- `MovieEpisode`
- `SearchFilterData`
- `SearchResults`
- `PlaySource`
- `PlayTrack`

## Playback Source Rules

### Source types

- `isFrame=false`: playable natively through AVPlayer.
- `isFrame=true`: not handled in the initial iOS release.

### Track semantics

- `kind=audio` and audio-like hints should map to audio tracks.
- `kind=subtitle`, `sub`, `caption`, or `captions` should map to subtitle tracks.
- A direct subtitle file should be treated as fallback subtitle metadata when no explicit subtitle track exists.

### Source selection

- Prefer the first playable direct stream source.
- Keep the selected source stable across track changes.
- If no playable direct stream exists, show a clear empty/error state instead of silently falling back to an unsupported embed path.

## Local Storage

The app should persist:

- liked movie identifiers and/or cards
- playback position per movie and episode

Recommended storage keys:

- `liked_movies`
- `liked_movie_ids`
- `playback_position:<movieId>:<episodeId>`

## Security / Decryption

The iOS client must include a dedicated decryptor for encrypted payloads so API parsing stays isolated from the feature layer.

Rules:

- Decryption belongs in `Core/Security`.
- Parsing should happen after successful decryption.
- Keys or derived secrets should be test-covered and documented.
- The implementation should prefer one deterministic path rather than multiple fallback decoders.

## Failure Modes

Expected failures should be handled explicitly:

- network unavailable
- HTTP error
- decryption failure
- malformed JSON
- empty source list
- unsupported frame-only playback set

## Tests

- Decryptor unit tests
- Search and playback mapping tests
- Track classification tests
- Source filtering tests
- Local storage read/write tests
