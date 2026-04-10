import Foundation

final class DefaultMotchillRepository: MotchillRepository, @unchecked Sendable {
    private let apiClient: MotchillAPIClient

    init(apiClient: MotchillAPIClient) {
        self.apiClient = apiClient
    }

    func loadHome() async throws -> [MotchillHomeSection] {
        try await apiClient.fetchHomeSections()
    }

    func loadNavbar() async throws -> [MotchillNavbarItem] {
        try await apiClient.fetchNavbar()
    }

    func loadDetail(slug: String) async throws -> MotchillMovieDetail {
        try await apiClient.fetchMovieDetail(slug: slug)
    }

    func loadPreview(slug: String) async throws -> MotchillMovieDetail {
        try await apiClient.fetchMoviePreview(slug: slug)
    }

    func loadSearchFilters() async throws -> MotchillSearchFilterData {
        try await apiClient.fetchSearchFilters()
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
    ) async throws -> MotchillSearchResults {
        try await apiClient.fetchSearchResults(
            categoryId: categoryId,
            countryId: countryId,
            typeRaw: typeRaw,
            year: year,
            orderBy: orderBy,
            isChieuRap: isChieuRap,
            is4k: is4k,
            search: search,
            pageNumber: pageNumber
        )
    }

    func loadEpisodeSources(
        movieID: Int,
        episodeID: Int,
        server: Int
    ) async throws -> [MotchillPlaySource] {
        try await apiClient.fetchEpisodeSources(
            movieId: movieID,
            episodeId: episodeID,
            server: server
        )
    }

    func loadPopupAd() async throws -> MotchillPopupAdConfig? {
        try await apiClient.fetchPopupAd()
    }
}
