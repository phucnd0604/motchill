# Task 6: Migrate Player Feature

## Goal

Move player lifecycle and playback UI state into TCA while keeping the AVPlayer runtime safe.

## Current Baseline

This plan has been updated to match the codebase after Phases 3 to 5:

- Home and Search are already reducer-owned.
- Detail is now fully migrated to TCA.
- Detail -> Player navigation is already centralized in `AppFeature`.
- Tapping an episode in Detail already appends a `PlayerFeature.State` route element with the real movie and episode payload.
- `PlayerFeature` already exists, but it is still only a placeholder reducer and view.
- The Player screen itself still runs through `PlayerViewModel`, `PlayerOverlay`, `PlayerSubtitleSupport`, and `PlayerView`.

Because of that, Phase 6 is no longer about navigation plumbing. It is about moving Player screen ownership into TCA without putting `AVPlayer` itself into reducer state.

## Files to Touch

- `swiftUI/Features/Player/PlayerView.swift`
- `swiftUI/Features/Player/PlayerViewModel.swift`
- `swiftUI/Features/Player/PlayerOverlay.swift`
- `swiftUI/Features/Player/PlayerSubtitleSupport.swift`
- `swiftUI/Features/Player/PlayerFeature.swift`
- `swiftUI/Features/Player/PlayerWebView.swift`
- `swiftUI/App/AppFeature.swift` only if the route payload needs a small adjustment after the Player state shape changes

## Implementation Steps

1. Expand `PlayerFeature.State` so it owns the screen-facing state the UI needs.
   - Keep the movie/episode identity and labels from Detail.
   - Add the current load phase, source selection, overlay visibility, subtitle/audio selection, playback progress snapshot, and any web fallback state needed by the UI.
   - Keep `AVPlayer`, timers, and other reference-heavy runtime objects out of reducer state.

2. Expand `PlayerFeature.Action` to cover the whole screen lifecycle.
   - `onAppear`
   - `loadResponse`
   - `retryTapped`
   - `backButtonTapped`
   - source selection
   - audio/subtitle selection
   - subtitle toggle
   - play/pause and seek intents
   - overlay show/hide
   - progress persistence and resume
   - iframe fallback selection if the current source cannot play directly

3. Move Player side effects into reducer effects behind dependencies.
   - Use dependencies for repository access, local playback persistence, remote playback sync, subtitle loading, and screen idle lock control.
   - Keep the actual player runtime isolated behind a helper/client so the reducer stays testable.
   - Preserve the current load -> resume -> play flow and make retry cancellable.

4. Convert `PlayerView` and the overlay UI to store-driven SwiftUI.
   - Replace direct `PlayerViewModel` ownership with `StoreOf<PlayerFeature>`.
   - Keep the current visual structure of the Player screen.
   - Make `PlayerOverlay` read its state from the store instead of mutating a view model directly.

5. Preserve iframe-only fallback behavior and error overlays.
   - If the repository only returns iframe sources, keep showing a fallback path instead of crashing or hiding the player.
   - Keep the current empty/error overlay behaviors intact.
   - If a web fallback is still needed, route it through reducer state rather than view-local state.

6. Remove the old `PlayerViewModel.swift` only after the TCA Player flow is verified.
   - Keep the runtime-heavy pieces out of reducer state.
   - Delete the legacy MVVM file only when the reducer-backed screen is stable in simulator smoke tests.

## Test Plan

- Add reducer tests for:
  - playable source load success
  - no-source and iframe-only error states
  - source switching
  - subtitle enable/disable
  - overlay show/hide behavior
  - progress persistence
  - resume behavior
  - close/back behavior
  - retry cancellation
  - iframe fallback selection if applicable

## Acceptance Criteria

- Player behavior still works under manual testing.
- Store state owns the visible UI behavior.
- AVPlayer runtime concerns stay isolated from pure reducer state.
- Detail -> Player navigation continues to work through `AppFeature`.
- The Player screen still handles direct streams, subtitle cues, and fallback paths without regressing current playback UX.
