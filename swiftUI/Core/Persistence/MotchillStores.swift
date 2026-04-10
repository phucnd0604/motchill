import Foundation

protocol MotchillLikedMovieStoring: Sendable {
    func loadMovies() async throws -> [MotchillMovieCard]
    func loadIDs() async throws -> Set<Int>
    func isLiked(movieID: Int) async throws -> Bool
    func toggle(movie: MotchillMovieCard) async throws -> [MotchillMovieCard]
}

protocol MotchillPlaybackPositionStoring: Sendable {
    func save(
        movieID: Int,
        episodeID: Int,
        positionMillis: Int64,
        durationMillis: Int64
    ) async throws

    func load(movieID: Int, episodeID: Int) async throws -> MotchillPlaybackProgressSnapshot?
}

actor UserDefaultsMotchillLikedMovieStore: MotchillLikedMovieStoring {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadMovies() async throws -> [MotchillMovieCard] {
        let encodedMovies = defaults.array(forKey: Self.moviesKey) as? [Data] ?? []
        if !encodedMovies.isEmpty {
            return try encodedMovies.map { try JSONDecoder().decode(MotchillMovieCard.self, from: $0) }
        }

        let ids = defaults.array(forKey: Self.movieIDsKey) as? [Int] ?? []
        return ids.map { movieID in
            MotchillMovieCard(
                id: movieID,
                name: "Movie \(movieID)",
                otherName: "",
                avatar: "",
                bannerThumb: "",
                avatarThumb: "",
                description: "",
                banner: "",
                imageIcon: "",
                link: "",
                quantity: "",
                rating: "",
                year: 0,
                statusTitle: "",
                statusRaw: "",
                statusText: "",
                director: "",
                time: "",
                trailer: "",
                showTimes: "",
                moreInfo: "",
                castString: "",
                episodesTotal: 0,
                viewNumber: 0,
                ratePoint: 0,
                photoUrls: [],
                previewPhotoUrls: []
            )
        }
    }

    func loadIDs() async throws -> Set<Int> {
        Set(try await loadMovies().map(\.id))
    }

    func isLiked(movieID: Int) async throws -> Bool {
        try await loadIDs().contains(movieID)
    }

    func toggle(movie: MotchillMovieCard) async throws -> [MotchillMovieCard] {
        var current = try await loadMovies()
        if let index = current.firstIndex(where: { $0.id == movie.id }) {
            current.remove(at: index)
        } else {
            current.append(movie)
        }
        try saveMovies(current)
        return current
    }

    private func saveMovies(_ movies: [MotchillMovieCard]) throws {
        let data = try movies.map { try JSONEncoder().encode($0) }
        defaults.set(data, forKey: Self.moviesKey)
        defaults.set(movies.map(\.id), forKey: Self.movieIDsKey)
    }

    private static let moviesKey = "liked_movies"
    private static let movieIDsKey = "liked_movie_ids"
}

actor UserDefaultsMotchillPlaybackPositionStore: MotchillPlaybackPositionStoring {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(
        movieID: Int,
        episodeID: Int,
        positionMillis: Int64,
        durationMillis: Int64
    ) async throws {
        let snapshot = MotchillPlaybackProgressSnapshot(
            positionMillis: positionMillis,
            durationMillis: max(durationMillis, 0)
        )
        let data = try JSONEncoder().encode(snapshot)
        defaults.set(data, forKey: Self.key(movieID: movieID, episodeID: episodeID))
    }

    func load(movieID: Int, episodeID: Int) async throws -> MotchillPlaybackProgressSnapshot? {
        guard let data = defaults.data(forKey: Self.key(movieID: movieID, episodeID: episodeID)) else {
            return nil
        }
        return try JSONDecoder().decode(MotchillPlaybackProgressSnapshot.self, from: data)
    }

    private static func key(movieID: Int, episodeID: Int) -> String {
        "playback_position:\(movieID):\(episodeID)"
    }
}
