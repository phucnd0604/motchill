# Native iOS Foundation Spec

## Summary

This document defines the first native iOS version of PhucTv in `swiftUI/`. The goal is to mirror the current Android architecture and product behavior as closely as practical while keeping the iOS codebase easy to extend in later phases.

The first implementation phase stays intentionally small:

- one independent iOS workspace
- one SwiftUI app target
- explicit package boundaries for app, core, data, domain, and feature code
- a data flow that matches Android: API -> repository -> state holder -> UI
- MVVM with `@Observable` as the default feature state pattern
- Kingfisher for remote image loading and caching

This spec is written for incremental delivery. Phase 0 builds the foundation only; later phases add real data flow and feature parity screen by screen.

## Goals

- Create a standalone native iOS app in `swiftUI/`.
- Keep parity with the current Android app's core behavior:
  - home feed
  - search and category entry points
  - detail page
  - player
  - liked-only local state
  - playback resume
  - direct stream playback for `isFrame=false`
- Use a conventional SwiftUI architecture that can scale without large rewrites.
- Use MVVM with `@Observable` so view ownership stays simple and predictable.
- Keep business rules visible and testable in Swift.

## Non-goals

- No Android changes.
- No backend redesign in phase 0.
- No browser-resolved embed handling in the initial iOS version.
- No UI redesign beyond what is needed for the native shell.
- No attempt to port every Flutter or Android implementation detail line by line.

## Architecture

### Project shape

`swiftUI/` is a standalone iOS application workspace. It starts as a single app target to reduce setup overhead, but the structure is deliberately layered so later work can split into additional modules if the codebase grows.

### Internal layers

- `App/`: application entry point, navigation shell, and top-level theme
- `Core/`: shared config, networking, storage, utilities, and design system
- `Data/`: DTOs, mappers, repository implementations, and API integrations
- `Domain/`: stable business models and use cases when the app needs an explicit boundary
- `Features/<name>/`: screen state, UI, and screen-specific logic

### State flow

The default flow is:

`UI -> ViewModel / state holder -> Repository -> Remote API / Local Storage -> mapped domain state -> UI`

Rules:

- UI should render state only and emit user events.
- State holders own screen state and orchestration.
- Repositories hide transport, encryption, and persistence details.
- Screen models should be stable enough to survive API shape changes.

### Recommended stack

- Swift
- SwiftUI
- MVVM with `@Observable` feature state holders
- URLSession with a small networking layer
- Codable-based DTO mapping unless a stronger reason appears later
- Kingfisher for remote image loading and caching
- SwiftData or a lightweight persistence layer for likes and resume, behind a stable interface
- AVPlayer for direct streams
- WebKit only if a later phase explicitly adds embed support
- XCTest for unit and repository tests

## Behavioral contracts

The iOS app must preserve the current product rules:

- Home renders sections from the public API and navigates to detail.
- Search supports filters, paging, and local liked-only filtering.
- Detail shows all real fields that exist in the API response and hides empty sections.
- Player distinguishes between direct streams and embedded sources.
- Phase 1 of iOS only plays `isFrame=false` sources natively.
- Playback resume is stored per episode.
- Liked items remain available locally even when the search API returns no result.

## Data contracts

The native app should preserve the same conceptual entities the Android app already uses:

- Home section and movie card
- Navbar/category item
- Popup ad config
- Movie detail
- Movie episode
- Search filter data
- Search result and pagination
- Play source and track

The actual Swift model names can differ, but their responsibilities should remain the same.

## Navigation

The app should expose the same navigation intent as the Android version:

- home
- search
- category preset search
- detail
- player

Category should behave like a preset search entry rather than a separate feature island.

## Phase plan

### Phase 0: Foundation

- Create the iOS workspace scaffold.
- Add the top-level architecture docs.
- Add the app shell, theme, and navigation placeholders.
- Prepare package boundaries for app, core, data, domain, and features.
- Keep the implementation small enough that the next phase can add data flow without undoing the shell.

### Phase 1: Data foundation

- Add API client, config, and request headers.
- Add payload decryption for search and playback responses.
- Add models and repository contracts.
- Add local storage for likes and resume behind a swappable persistence adapter.
- Implement the data layer with `Codable` DTOs and `Alamofire` request execution.
- Keep direct-stream-only playback semantics and leave `isFrame=true` embeds out of scope.

### Phase 2: Home

- Render the home feed.
- Wire navigation to detail and search.
- Add loading, empty, and error states.

### Phase 3: Detail

- Render the cinematic detail screen.
- Show episodes, gallery, related items, and like/unlike behavior.
- Keep the UI data-first and hide empty sections.

### Phase 4: Player

- Add direct stream playback.
- Keep embedded source handling out of the initial release.
- Add source switching, resume, and track selection for playable stream sources.

### Phase 5: Search and category

- Add filter sheets, paging, and category presets.
- Add liked-only local search behavior.
- Preserve route parameter parity with Android where relevant.

### Phase 6: Hardening

- Add tests for model mapping, decryption, and screen logic.
- Run simulator verification on the main flow.
- Polish edge cases and release packaging.

## Phase 0 acceptance criteria

- The `swiftUI/` workspace exists.
- The project structure clearly shows the intended architecture boundaries.
- A SwiftUI app shell can be opened and expanded in later phases.
- The spec lives inside `swiftUI/docs/` and describes the long-term architecture clearly enough to guide later work.

## Phase 1 checkpoint

Phase 1 is considered complete when:

- API requests are handled by the iOS networking layer without ad hoc JSON parsing in features.
- Encrypted search and playback payloads decode successfully into domain models.
- Likes and resume storage are available behind stable interfaces.
- The app builds successfully on the simulator after the data foundation refactor.
- The codebase is ready to start home-screen feature work without revisiting transport architecture.

## Assumptions

- The iOS app will start as a standalone workspace, not a module inside another app.
- The backend stays unchanged for phase 0.
- The first implementation wave prioritizes parity and extensibility over micro-optimizations.
