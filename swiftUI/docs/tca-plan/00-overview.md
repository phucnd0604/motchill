# TCA Migration Overview

## Status

- Phase 1 is complete.
- TCA package integration is in place.
- The app has a root `AppFeature` scaffold and dependency registration for the first migration slice.

## Goal

Move the SwiftUI app from `@Observable` MVVM and custom routing to TCA in a controlled, incremental way.

## Current State

- App shell uses `AppShellView`, `AppRouter`, and `AppRoute`.
- Feature screens are currently driven by view models:
  - `HomeViewModel`
  - `SearchViewModel`
  - `DetailViewModel`
  - `PlayerViewModel`
- Core services already exist and should be reused:
  - repository
  - liked movie store
  - playback position store
  - remote config client/store
  - auth manager
  - screen idle manager

## Migration Strategy

- Build a small TCA foundation first. This is now complete.
- Convert the shell and routing layer before migrating feature logic.
- Migrate features in this order:
  1. Home
  2. Search
  3. Detail
  4. Player
- Keep UI structure and copy stable while changing state management.
- Use reducer tests to prove behavior before deleting the old implementation.

## Non-Goals for the First Pass

- Do not rewrite the data layer.
- Do not rewrite Supabase integration.
- Do not refactor the design system at the same time.
- Do not split the project into multiple modules yet.

## Success Criteria

- Phase 1 adds TCA foundation code without changing visible app behavior.
- Each migrated feature has a TCA reducer and tests.
- Navigation works through TCA state instead of `AppRouter`.
- The app builds and runs after each task.
- The old MVVM code can be deleted only after its replacement is stable.

## Phase 1 Summary

Phase 1 established the minimum TCA runtime boundary needed for the rest of the migration:

- added the `swift-composable-architecture` package to the Xcode project
- registered the package product on the app target
- added a TCA dependency bridge in `AppDependencies+TCA.swift`
- exposed app services through `DependencyValues`
- created a root `AppFeature` reducer scaffold
- verified the app still builds after the integration

This phase does not change shell routing or feature screens yet. It only prepares the app to migrate those pieces safely in later phases.
