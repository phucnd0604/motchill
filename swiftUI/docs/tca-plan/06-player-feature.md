# Task 6: Migrate Player Feature

## Goal

Move player lifecycle and playback UI state into TCA while keeping the AVPlayer runtime safe.

## Files to Touch

- `swiftUI/Features/Player/PlayerView.swift`
- `swiftUI/Features/Player/PlayerViewModel.swift`
- `swiftUI/Features/Player/PlayerOverlay.swift`
- `swiftUI/Features/Player/PlayerSubtitleSupport.swift`

## Implementation Steps

1. Create a `PlayerFeature` reducer.
2. Keep `AVPlayer` and other reference-heavy runtime pieces out of reducer state.
3. Move source selection, overlay visibility, and subtitle/audio selection into state/actions.
4. Move load, retry, resume, progress persistence, and close/back behavior into the reducer.
5. Wrap side effects behind dependencies where needed.
6. Preserve iframe-only fallback behavior and error overlays.
7. Remove the old view model only after manual smoke testing is stable.

## Test Plan

- Add reducer tests for:
  - playable source load success
  - no-source and iframe-only error states
  - source switching
  - subtitle enable/disable
  - progress persistence
  - resume behavior
  - close/back behavior

## Acceptance Criteria

- Player behavior still works under manual testing.
- Store state owns the visible UI behavior.
- AVPlayer runtime concerns stay isolated from pure reducer state.
