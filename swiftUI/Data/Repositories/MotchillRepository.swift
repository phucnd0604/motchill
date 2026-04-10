import Foundation

protocol MotchillRepository: Sendable {
    func loadHome() async throws -> [MotchillHomeSection]
    func loadNavbar() async throws -> [MotchillNavbarItem]
    func loadDetail(slug: String) async throws -> MotchillMovieDetail
    func loadPreview(slug: String) async throws -> MotchillMovieDetail
    func loadSearchFilters() async throws -> MotchillSearchFilterData
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
    ) async throws -> MotchillSearchResults
    func loadEpisodeSources(
        movieID: Int,
        episodeID: Int,
        server: Int
    ) async throws -> [MotchillPlaySource]
    func loadPopupAd() async throws -> MotchillPopupAdConfig?
}
