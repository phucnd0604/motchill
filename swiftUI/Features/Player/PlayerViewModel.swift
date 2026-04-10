import Observation

@Observable
final class PlayerViewModel {
    let title = "Player"
    let subtitle = "Direct stream only"
    let bodyText = "Phase 0 treats the player as a direct-stream shell. Embedded sources are intentionally deferred to a later phase."
    let bullets = [
        "AVPlayer is the playback engine for `isFrame=false` sources.",
        "Resume will be stored per episode in a later phase.",
        "Track selection and source switching will land after data foundation.",
    ]
}
