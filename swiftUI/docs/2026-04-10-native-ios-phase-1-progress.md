# Native iOS Phase 1 Progress

## Status

Phase 1 is complete for the current foundation scope.

The app now has a real data foundation built in the `swiftUI/` workspace, with an Apple-native implementation style:

- `Codable` DTOs and domain mapping
- `Alamofire` networking with async/await
- payload decryption for encrypted search and playback endpoints
- local persistence abstractions for likes and resume
- Kingfisher already prepared for remote image loading and caching

## What Was Delivered

- Standalone iOS workspace and app target remain intact.
- API client now uses `Alamofire` instead of manual `URLSession` request wiring.
- API payloads decode through `JSONDecoder` and DTOs instead of `JSONSerialization`.
- Domain models stay isolated from transport concerns.
- Search and playback encrypted payloads still go through the existing decryptor before decoding.
- Local storage abstractions for likes and playback position are in place behind swappable stores.
- The project builds successfully on the simulator after the refactor.

## Technical Decisions Locked In

- iOS minimum target stays at 18.0.
- MVVM remains the feature pattern.
- `@Observable` stays the default state-holder style.
- `Codable` is the canonical data-contract path.
- `Alamofire` is the networking layer for request execution and response serialization.
- `Kingfisher` is the image caching layer.
- Direct stream playback remains the only supported player path for phase 1.
- `isFrame=true` sources are intentionally still excluded from native playback.

## Known Gaps Kept Intentionally

- No browser-resolved embed flow yet.
- No playback UI or detail UI parity work yet in this phase.
- No wired XCTest target in the scheme yet, although test files exist as scaffold.
- The decryptor still uses the existing OpenSSL-style MD5-based derivation, which produces a compiler warning but does not block the build.

## Phase 2 Input

Phase 2 should build on this foundation without reworking the transport layer:

- reuse the `PhucTvAPIClient` and DTO/domain mapping path
- keep the repository contract stable
- add the home screen state flow and rendering first
- keep navigation parity with Android at the route level, not by copying view structure
- continue treating `isFrame=true` as out of scope for native playback

## Ready For Phase 2

The foundation is now stable enough to move into feature work. Phase 2 can focus on home screen rendering and route wiring without reopening the data stack.
