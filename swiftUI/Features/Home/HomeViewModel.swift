import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    @ObservationIgnored
    private let repository: PhucTvRepository
    @ObservationIgnored
    private let remoteConfigClient: PhucTvRemoteConfigLoading
    @ObservationIgnored
    private let remoteConfigStore: PhucTvRemoteConfigStoring
    var selectedMovie: PhucTvMovieCard?
    var selectedSection: PhucTvHomeSection? {
        didSet {
            guard let selectedSection = selectedSection else {
                selectedMovie = nil
                return
            }

            guard let selectedMovieID = selectedMovie?.id else {
                selectedMovie = selectedSection.products.first
                return
            }

            // Rebind selection to the current section's instance so TabView selection
            // keeps matching `.tag(currentMovie)` and does not jump back to first tab.
            selectedMovie = selectedSection.products.first(where: { $0.id == selectedMovieID })
                ?? selectedSection.products.first
        }
    }
    var state: HomeScreenState {
        didSet {
            guard case .loaded = state else { return }

            if let selectedSection,
               let selectedMovieID = selectedMovie?.id,
               let refreshedSection = sections.first(where: { $0.id == selectedSection.id }),
               let refreshedMovie = refreshedSection.products.first(where: { $0.id == selectedMovieID }) {
                self.selectedSection = refreshedSection
                self.selectedMovie = refreshedMovie
            }
        }
    }

    init(
        repository: PhucTvRepository,
        state: HomeScreenState = .loading,
        remoteConfigClient: PhucTvRemoteConfigLoading = PhucTvRemoteConfigClient(),
        remoteConfigStore: PhucTvRemoteConfigStoring = PhucTvRemoteConfigStore.shared
    ) {
        self.repository = repository
        self.state = state
        self.remoteConfigClient = remoteConfigClient
        self.remoteConfigStore = remoteConfigStore
    }

    var loadedContent: HomeFeedContent? {
        if case let .loaded(content) = state {
            return content
        }
        return nil
    }

    var sections: [PhucTvHomeSection] {
        loadedContent?.sections ?? []
    }

    var heroSection: PhucTvHomeSection? {
        sections.first(where: { $0.key == "slide" }) ?? sections.first
    }

    var heroMovies: [PhucTvMovieCard] {
        Array(heroSection?.products.prefix(6) ?? [])
    }

    var contentSections: [PhucTvHomeSection] {
        guard sections.contains(where: { $0.key == "slide" }) else {
            return sections
        }

        return sections.filter { $0.key != "slide" }
    }

    var hasRenderableContent: Bool {
        sections.contains(where: { !$0.products.isEmpty })
    }

    func load() async {
        state = .loading

        do {
            let remoteConfig = try await remoteConfigClient.fetchRemoteConfig()
            remoteConfigStore.update(remoteConfig)
            let sections = try await repository.loadHome()
            if sections.isEmpty {
                state = .empty
            } else {
                state = .loaded(HomeFeedContent(sections: sections))
                if selectedSection == nil {
                    selectedSection = sections.first
                }
                if selectedMovie == nil {
                    selectedMovie = selectedSection?.products.first
                }
            }
        } catch {
            PhucTvLogger.shared.error(
                error,
                message: "Home load failed",
                metadata: [
                    "state": "home",
                ]
            )
            state = .error(message: error.localizedDescription)
        }
    }

    func retry() async {
        await load()
    }

    static func previewLoaded() -> HomeViewModel {
        HomeViewModel(
            repository: PreviewHomeRepository(sections: HomeMockData.loadedSections),
            state: .loaded(HomeFeedContent(sections: HomeMockData.loadedSections))
        )
    }

    static func previewLoading() -> HomeViewModel {
        HomeViewModel(
            repository: PreviewHomeRepository(sections: HomeMockData.emptySections),
            state: .loading
        )
    }

    static func previewEmpty() -> HomeViewModel {
        HomeViewModel(
            repository: PreviewHomeRepository(sections: HomeMockData.emptySections),
            state: .empty
        )
    }

    static func previewError() -> HomeViewModel {
        HomeViewModel(
            repository: PreviewHomeRepository(sections: HomeMockData.loadedSections),
            state: .error(message: "Không thể tải nội dung ngay lúc này.")
        )
    }
}

private struct PreviewHomeRepository: PhucTvRepository {
    let sections: [PhucTvHomeSection]

    func loadHome() async throws -> [PhucTvHomeSection] {
        sections
    }

    func loadNavbar() async throws -> [PhucTvNavbarItem] {
        []
    }

    func loadDetail(slug: String) async throws -> PhucTvMovieDetail {
        throw NSError(domain: "PreviewHomeRepository", code: 1)
    }

    func loadPreview(slug: String) async throws -> PhucTvMovieDetail {
        throw NSError(domain: "PreviewHomeRepository", code: 1)
    }

    func loadSearchFilters() async throws -> PhucTvSearchFilterData {
        throw NSError(domain: "PreviewHomeRepository", code: 1)
    }

    func loadSearchResults(
        categoryId: Int?,
        countryId: Int?,
        typeRaw: String,
        year: String,
        orderBy: String,
        isChieuRap: Bool,
        is4k: Bool,
        search: String,
        pageNumber: Int
    ) async throws -> PhucTvSearchResults {
        throw NSError(domain: "PreviewHomeRepository", code: 1)
    }

    func loadEpisodeSources(
        movieID: Int,
        episodeID: Int,
        server: Int
    ) async throws -> [PhucTvPlaySource] {
        throw NSError(domain: "PreviewHomeRepository", code: 1)
    }

    func loadPopupAd() async throws -> PhucTvPopupAdConfig? {
        nil
    }
}
