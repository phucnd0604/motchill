import Observation

@Observable
final class DetailViewModel {
    let title = "Detail"
    let subtitle = "Movie metadata"
    let bodyText = "Detail will render movie metadata, episode groups, gallery content, and related items when data foundation is wired up."
    let bullets = [
        "Hide empty sections rather than showing placeholders.",
        "Episode selection feeds the player route.",
        "Like state remains local even when the search API is empty.",
    ]
}
