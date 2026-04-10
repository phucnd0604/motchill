# Native iOS Architecture

## Overview

The iOS app follows the same product shape as the Android version: a single native client that talks directly to the public Motchill API, maps the API into stable domain models, and drives feature state through small feature-owned state holders.

The architecture is deliberately boring and explicit. That keeps debugging simple and makes it easier to reason about parity between platforms.

## App Layers

### App

- App entry point
- Navigation shell
- Dependency wiring
- Top-level theming

### Core

- Configuration and environment
- Networking and request headers
- Payload decryption
- Persistence abstractions
- Shared utilities

### Data

- DTOs
- JSON mapping
- Repository implementations
- API adapters

### Domain

- Stable movie, search, and playback models
- Small selection helpers
- State-independent business rules

### Features

- Home
- Search
- Detail
- Player
- Shared feature subviews when needed

## State Flow

The intended flow is:

`View -> Feature state holder -> Repository -> API / persistence -> mapped domain state -> View`

Rules:

- Views never fetch directly.
- Feature state holders should use `@Observable` when the view owns the instance.
- Feature state holders own loading, selection, and error transitions.
- Repositories own API calls, decryption, and parsing.
- Domain models stay stable even if the API shape shifts.

## Module Boundaries

The first version can remain a single Xcode workspace with folder boundaries instead of separate packages, but the code should be organized as if each layer could be extracted later.

Recommended folder map:

- `App/`
- `Core/Networking/`
- `Core/Security/`
- `Core/Persistence/`
- `Domain/Models/`
- `Data/DTOs/`
- `Data/Mappers/`
- `Data/Repositories/`
- `Features/Home/`
- `Features/Search/`
- `Features/Detail/`
- `Features/Player/`

## Technology Choices

### UI

SwiftUI is the default UI system for all screens.

### State

Use `@Observable` consistently within the feature layer. Avoid mixing state patterns inside the same feature unless there is a strong reason.

### Networking

Use an `Alamofire`-backed networking layer with a small wrapper that handles:

- base URL
- common headers
- response text retrieval
- errors and retries

Decoding should flow through `Codable` DTOs, with domain mapping kept explicit so the app can absorb API quirks without leaking them into feature code.

### Persistence

Use a simple storage abstraction for:

- liked movies
- resume position per episode

The persistence backend can be chosen later, but the interface should be stable from day one.

### Playback

Use AVPlayer for direct stream playback.

Embedded source handling is out of scope for the first iOS version and should not influence the initial architecture.

### Remote Images

Use Kingfisher for remote image loading and caching. Keep image presentation in a thin wrapper view so features do not depend on Kingfisher details directly.

## Navigation Model

Navigation should mirror the product's conceptual routes rather than the exact UI hierarchy:

- home route
- search route
- category preset route
- detail route
- player route

Keep route inputs small and serializable:

- movie slug or id
- episode id
- optional search preset parameters

## Feature Responsibilities

### Home

- Load home sections
- Open detail pages
- Open search entry points

### Search

- Load search filters
- Handle query/filter state
- Support pagination and liked-only behavior

### Detail

- Render movie metadata
- Render episodes and related items
- Launch the player with the selected episode

### Player

- Load source list for an episode
- Filter for playable direct streams
- Apply resume position
- Handle audio and subtitle tracks when present

## Error Handling

Each layer should convert technical failures into user-facing state as early as possible:

- Networking returns typed failure information.
- Repositories collapse transport and parsing issues into domain-level errors.
- Features decide whether to show inline errors, retry affordances, or empty states.

## Testing Strategy

- Unit test mapping and selection rules.
- Unit test decryption and payload parsing.
- Unit test feature state transitions.
- Use simulator verification for navigation and player flow.
