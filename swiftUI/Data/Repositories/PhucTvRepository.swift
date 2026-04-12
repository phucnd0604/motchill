import Foundation

protocol PhucTvRepository: Sendable {
    func loadHome() async throws -> [PhucTvHomeSection]
    func loadNavbar() async throws -> [PhucTvNavbarItem]
    func loadDetail(slug: String) async throws -> PhucTvMovieDetail
    func loadPreview(slug: String) async throws -> PhucTvMovieDetail
    func loadSearchFilters() async throws -> PhucTvSearchFilterData
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
    ) async throws -> PhucTvSearchResults
    func loadEpisodeSources(
        movieID: Int,
        episodeID: Int,
        server: Int
    ) async throws -> [PhucTvPlaySource]
    func loadPopupAd() async throws -> PhucTvPopupAdConfig?
}
