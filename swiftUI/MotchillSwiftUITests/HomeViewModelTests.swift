import XCTest
@testable import MotchillSwiftUI

@MainActor
final class HomeViewModelTests: XCTestCase {
    func testLoadPopulatesLoadedState() async {
        let repository = StubHomeRepository(result: .success(HomeMockData.loadedSections))
        let viewModel = HomeViewModel(repository: repository)

        await viewModel.load()

        XCTAssertEqual(viewModel.sections.count, HomeMockData.loadedSections.count)
        XCTAssertEqual(viewModel.heroMovies.count, 6)
        XCTAssertFalse(viewModel.contentSections.isEmpty)
    }

    func testLoadShowsErrorStateOnFailure() async {
        let repository = StubHomeRepository(result: .failure(StubError.failed))
        let viewModel = HomeViewModel(repository: repository)

        await viewModel.load()

        if case let .error(message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }

    func testPreviewLoadedProvidesHeroMovies() {
        let viewModel = HomeViewModel.previewLoaded()

        XCTAssertEqual(viewModel.heroMovies.count, 6)
        XCTAssertEqual(viewModel.heroMovies.first?.id, HomeMockData.loadedSections[0].products.first?.id)
    }

    func testRetryRestoresLoadedPreviewState() async {
        let viewModel = HomeViewModel.previewError()

        XCTAssertNil(viewModel.loadedContent)

        await viewModel.retry()

        XCTAssertEqual(viewModel.sections.count, HomeMockData.loadedSections.count)
        XCTAssertEqual(viewModel.heroMovies.count, 6)
    }
}

private final class StubHomeRepository: MotchillRepository, @unchecked Sendable {
    enum Result {
        case success([MotchillHomeSection])
        case failure(Error)
    }

    let result: Result

    init(result: Result) {
        self.result = result
    }

    func loadHome() async throws -> [MotchillHomeSection] {
        switch result {
        case let .success(sections):
            return sections
        case let .failure(error):
            throw error
        }
    }

    func loadNavbar() async throws -> [MotchillNavbarItem] { [] }
    func loadDetail(slug: String) async throws -> MotchillMovieDetail { throw StubError.failed }
    func loadPreview(slug: String) async throws -> MotchillMovieDetail { throw StubError.failed }
    func loadSearchFilters() async throws -> MotchillSearchFilterData { throw StubError.failed }
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
    ) async throws -> MotchillSearchResults { throw StubError.failed }
    func loadEpisodeSources(
        movieID: Int,
        episodeID: Int,
        server: Int
    ) async throws -> [MotchillPlaySource] { [] }
    func loadPopupAd() async throws -> MotchillPopupAdConfig? { nil }
}

private enum StubError: Error {
    case failed
}
