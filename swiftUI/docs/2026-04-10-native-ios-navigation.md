# Native iOS Navigation

## Route Map

The iOS app should preserve the same conceptual navigation as the Android app:

- home
- search
- category preset search
- detail
- player

## Navigation Rules

- Home is the landing route.
- Search is the shared screen for manual search and category presets.
- Category behaves like a prefilled search entry point, not a separate branch.
- Detail is the main content route after selecting a movie.
- Player is opened from an episode inside detail.

## Route Inputs

Keep route inputs small, serializable, and stable:

- movie slug or id
- episode id
- optional search parameters

Prefer route data that can be restored from API or local state instead of passing large objects around.

## State Ownership

- App-level navigation owns the current stack.
- Feature state holders own screen-local state.
- The player should not own app navigation history; it only requests dismissal or transition back.

## UX Rules

- Preserve back behavior consistently across all screens.
- Search should restore its active filters when navigated back to.
- Detail should keep the selected episode stable while launching the player.
- The player should exit cleanly and return the user to the detail screen.

## Testing

- Verify route transitions from home to detail to player.
- Verify search and category entry points restore expected filters.
- Verify back navigation preserves screen-local state where appropriate.
