# API, Data, and Storage

## 1. API Endpoints

- `GET /api/moviehomepage`
- `GET /api/movie/:slug`
- `GET /api/movie/preview/:slug`
- `GET /api/navbar`
- `GET /api/ads/popup`
- `GET /api/filter`
- `GET /api/search`
- `GET /api/play/get?movieId=...&episodeId=...&server=...`

## 2. Request Behavior

- Base URL comes from `MOTCHILL_PUBLIC_API_BASE_URL`, defaulting to `https://motchilltv.taxi`.
- Requests use a browser-like `User-Agent`.
- Play payloads are encrypted and decoded locally before mapping into domain models.

## 3. Playback Payload Shape

The app currently treats `/api/play/get` as a source list response with these fields:

- `SourceId`
- `ServerName`
- `Link`
- `Subtitle`
- `Type`
- `IsFrame`
- `Quality`
- `Tracks`

### Track Mapping Rules

- `kind=audio` and similar audio hints are treated as audio tracks.
- `kind=subtitle`, `sub`, `caption`, or `captions` are treated as subtitle tracks.
- `Tracks` with `kind=captions` and `.vtt` files are subtitle metadata, not audio dubbing.
- If `Subtitle` contains a subtitle file and no explicit subtitle track exists, it can be used as fallback subtitle metadata.

## 4. Data Models

### Home / Catalog

- `HomeSection`
- `MovieCard`
- `NavbarItem`
- `PopupAdConfig`
- `SimpleLabel`
- `MovieEpisode`
- `MovieDetail`

### Search

- `SearchFacetOption`
- `SearchFilterData`
- `SearchChoice`
- `SearchPagination`
- `SearchResults`

### Playback

- `PlaySource`
- `PlayTrack`

## 5. Local Storage

### Liked Movies

- `liked_movie_cards`
- `liked_movie_ids`

### Playback Resume

- `player_position:<movieId>:<episodeId>`
- Stores playback position per episode.

## 6. Business Rules

- Source `isFrame=true` is excluded from the native playable rail.
- Native playback only shows stream sources.
- Source choice defaults to the first playable stream source.
- Audio/subtitle menu items appear only when the selected source exposes matching tracks.
- The current native player keeps playback position and source selection local to the episode session.
