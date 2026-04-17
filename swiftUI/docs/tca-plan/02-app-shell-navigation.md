# Task 2: Move App Shell and Navigation to TCA

## Goal

Replace the custom router with TCA-driven app state and navigation.

## Files to Touch

- `swiftUI/App/AppShellView.swift`
- `swiftUI/App/AppRouter.swift`
- `swiftUI/App/AppRoute.swift`
- new app feature files such as `swiftUI/App/AppFeature.swift`
- auth presentation code that currently lives in the shell

## Implementation Steps

1. Model app-wide state in a reducer.
2. Move route stack state into TCA navigation state.
3. Convert `onOpenURL` handling into an action/effect path.
4. Move auth banner visibility and sheet presentation into the reducer.
5. Update `AppShellView` to read from a `Store`.
6. Keep the route enum shape stable if possible so feature migration is easier.
7. Remove direct shell dependence on `AppRouter` once TCA navigation is working.

## Test Plan

- Add reducer tests for:
  - push search route
  - push detail route
  - push player route
  - pop route
  - present auth sheet
  - handle auth callback URL
- Confirm the shell still launches and renders the correct initial screen.

## Acceptance Criteria

- App navigation is controlled by TCA state.
- `AppRouter` is no longer required for new navigation work.
- Search/detail/player can still be reached through the shell.
