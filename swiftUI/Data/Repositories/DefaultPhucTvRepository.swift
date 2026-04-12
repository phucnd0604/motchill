import Foundation

final class DefaultPhucTvRepository: PhucTvRepository, @unchecked Sendable {
    private let apiClient: PhucTvAPIClient

    init(apiClient: PhucTvAPIClient) {
        self.apiClient = apiClient
    }

    func loadHome() async throws -> [PhucTvHomeSection] {
        try await apiClient.fetchHomeSections()
    }

    func loadNavbar() async throws -> [PhucTvNavbarItem] {
        try await apiClient.fetchNavbar()
    }

    func loadDetail(slug: String) async throws -> PhucTvMovieDetail {
        try await apiClient.fetchMovieDetail(slug: slug)
    }

    func loadPreview(slug: String) async throws -> PhucTvMovieDetail {
        try await apiClient.fetchMoviePreview(slug: slug)
    }

    func loadSearchFilters() async throws -> PhucTvSearchFilterData {
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
    ) async throws -> PhucTvSearchResults {
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
    ) async throws -> [PhucTvPlaySource] {
        try await apiClient.fetchEpisodeSources(
            movieId: movieID,
            episodeId: episodeID,
            server: server
        )
    }

    func loadPopupAd() async throws -> PhucTvPopupAdConfig? {
        try await apiClient.fetchPopupAd()
    }
}
