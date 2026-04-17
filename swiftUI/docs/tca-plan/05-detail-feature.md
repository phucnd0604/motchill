# Task 5: Migrate Detail Feature

## Goal

Move Detail loading, selection, and like/progress behavior into TCA.

## Files to Touch

- `swiftUI/Features/Detail/DetailView.swift`
- `swiftUI/Features/Detail/DetailViewModel.swift`
- `swiftUI/Features/Detail/DetailPresentation.swift`
- Detail-specific state and helper files only if they belong to feature logic

## Implementation Steps

1. Create a `DetailFeature` reducer.
2. Move load/retry logic into reducer effects.
3. Move liked-state toggling into reducer actions.
4. Move episode progress loading into reducer state/effects.
5. Keep tab selection validation inside the reducer.
6. Keep computed presentation values as pure helpers where possible.
7. Route player navigation through an explicit reducer action/delegate.

## Test Plan

- Add reducer tests for:
  - detail load success
  - detail load failure
  - like toggle success
  - invalid tab selection ignored
  - episode progress refresh
  - open-player delegate action

## Acceptance Criteria

- Detail behavior matches the current UI and data flow.
- The feature no longer depends on the old view model for state ownership.
