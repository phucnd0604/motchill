import Foundation

@MainActor
final class AppContainer {
    static let shared = AppContainer()

    let configuration = AppConfiguration()
    let apiClient: MotchillAPIClient
    let repository: MotchillRepository
    let likedMovieStore: MotchillLikedMovieStoring
    let playbackPositionStore: MotchillPlaybackPositionStoring

    private init() {
        _ = MotchillLogger.shared
        apiClient = MotchillAPIClient(configuration: configuration)
        repository = DefaultMotchillRepository(apiClient: apiClient)
        likedMovieStore = UserDefaultsMotchillLikedMovieStore()
        playbackPositionStore = UserDefaultsMotchillPlaybackPositionStore()
    }
}
