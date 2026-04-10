# Native iOS Player

## Player Goal

The first iOS player should behave like the Android player for direct streams:

- load episode sources
- filter to playable direct streams
- start from resume position when available
- support source switching
- support audio and subtitle tracks when present

Embedded sources are intentionally out of scope for this version.

## Player Architecture

Use a split between:

- a feature state holder that owns source selection, loading state, and errors
- a playback engine that owns AVPlayer and runtime playback state
- a small UI layer that binds controls to state

That separation keeps source selection and playback side effects easy to test independently.

## Playback Flow

1. The detail screen opens the player for a specific episode.
2. The player asks the repository for the decrypted source list.
3. The feature layer filters the list to `isFrame=false` sources only.
4. The first playable source becomes the default selection.
5. The playback engine loads the selected source through AVPlayer.
6. Resume position is applied if it exists.
7. Audio and subtitle tracks are shown only when the selected source exposes them.

## Source Switching

- Switching source should reload playback from the current position when possible.
- Track selection should stay attached to the selected source.
- If a source fails to initialize, the UI should surface a retryable error instead of silently continuing.

## Resume Behavior

- Resume should be stored per episode.
- Resume should be flushed when the player exits or pauses in a way that risks losing position.
- A missing resume record should simply start from zero.

## Track Rules

### Audio

- Audio tracks appear only when the selected source includes audio metadata.
- Default audio should be selected from explicit track defaults first.

### Subtitles

- Subtitle tracks appear only when the selected source exposes subtitle metadata or a fallback subtitle file.
- Default subtitle should be selected from explicit track defaults first.

## Error Handling

The player should distinguish between:

- loading failures
- no playable source found
- playback initialization failures
- runtime playback failures

User-facing responses should be specific enough that the user can tell whether to retry, select another source, or go back.

## UI Expectations

- Keep player chrome separate from playback engine state.
- Keep controls simple and focus on stability over visual complexity.
- Match Android behavior closely for source rail visibility, track buttons, and resume.

## Validation

- Unit test source filtering.
- Unit test default track selection.
- Unit test playback state transitions.
- Run simulator playback checks against at least one direct stream source.
