import Observation

@Observable
final class SearchViewModel {
    let title = "Search"
    let subtitle = "Category + filters"
    let bodyText = "Search will share the same screen for direct query and category presets once phase 1 data foundation lands."
    let bullets = [
        "Filter and paging behavior stays feature-owned.",
        "Category is modeled as a preset search entry point.",
        "Liked-only filtering stays local to the client.",
    ]
}
