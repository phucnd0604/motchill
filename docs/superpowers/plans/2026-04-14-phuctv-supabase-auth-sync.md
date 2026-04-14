# PhucTv Supabase Auth + Cloud Sync Plan

> **For agentic workers:** implement this only after the plan is confirmed. Keep the existing content repository intact and change only auth/session and user-scoped persistence.

**Goal:** Add Supabase-backed login and cloud sync for liked movies and playback positions in the PhucTv SwiftUI app.

**Architecture:** Keep the current repository for catalog/detail/search/playback-source loading. Add a Supabase auth/session layer plus two user-scoped stores backed by Postgres tables with RLS. Auth should gate only personal actions unless the product decision changes later.

**Tech Stack:** SwiftUI, Supabase Swift, AuthenticationServices, Keychain, Postgres RLS

### Planned Changes

- Add Supabase client/bootstrap to app dependency wiring.
- Add login UI for email/password and Sign in with Apple.
- Replace local like and playback stores with Supabase-backed implementations.
- Add database tables for liked movies and playback positions.
- Add RLS policies so each user can only access their own rows.

### Data Model

- `liked_movies`
  - `user_id`
  - `movie_id`
  - `movie_snapshot`
  - `created_at`
  - unique per user and movie
- `playback_positions`
  - `user_id`
  - `movie_id`
  - `episode_id`
  - `position_ms`
  - `duration_ms`
  - `updated_at`
  - unique per user, movie, and episode

### Test Plan

- Verify auth session restore on app launch.
- Verify sign-in and sign-out state transitions.
- Verify liked movies persist per user and do not leak across accounts.
- Verify playback resume persists per user and per episode.
- Verify RLS blocks cross-user reads and writes.

### Assumptions

- No migration of the current local `UserDefaults` data into Supabase.
- Catalog/content fetching remains on the existing API.
- Playback position stays keyed by `movie + episode`.
- Personal features should be unavailable until the user logs in, but browsing the app remains open.

