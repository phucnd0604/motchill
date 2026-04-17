# Task 7: Cleanup and Stabilization

## Goal

Remove the old MVVM/router leftovers and make the TCA migration the only active app architecture.

## Files to Touch

- `swiftUI/App/AppRouter.swift`
- migrated `*ViewModel.swift` files
- any now-unused presentation helpers
- previews and tests that still instantiate the old architecture

## Implementation Steps

1. Remove dead code that is no longer referenced by migrated features.
2. Update previews to construct `Store` values instead of view models.
3. Convert the remaining tests to reducer tests where applicable.
4. Standardize shared dependency and effect patterns that emerged during migration.
5. Verify the app shell, feature navigation, and side effects all run through TCA.

## Test Plan

- Run the full `swiftUI/PhucTVTests` suite.
- Do a simulator smoke test through:
  - Home
  - Search
  - Detail
  - Player
- Fix any regressions before removing more legacy code.

## Acceptance Criteria

- The app builds without the legacy router/view-model path.
- The TCA path is the only active architecture for migrated screens.
- The test suite remains green.
