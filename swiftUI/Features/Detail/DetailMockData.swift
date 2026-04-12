import Foundation

enum DetailMockData {
    static let movie: PhucTvMovieCard = HomeMockData.loadedSections[0].products[0]

    static let detail: PhucTvMovieDetail = {
        let base = movie
        return PhucTvMovieDetail(
            movie: PhucTvMovieCard(
                id: base.id,
                name: base.name,
                otherName: base.otherName,
                avatar: base.avatar,
                bannerThumb: base.bannerThumb,
                avatarThumb: base.avatarThumb,
                description: base.description,
                banner: base.banner,
                imageIcon: base.imageIcon,
                link: base.link,
                quantity: base.quantity,
                rating: base.rating,
                year: base.year,
                statusTitle: base.statusTitle,
                statusRaw: base.statusRaw,
                statusText: base.statusText,
                director: "Denis Villeneuve",
                time: "2h 46m",
                trailer: "https://www.youtube.com/watch?v=Way9Dexny3w",
                showTimes: "Prime time",
                moreInfo: "Epic sci-fi adventure centered on Arrakis and the rise of Paul Atreides.",
                castString: "Timothée Chalamet, Zendaya, Rebecca Ferguson",
                episodesTotal: 1,
                viewNumber: 1_200_000,
                ratePoint: 8.8,
                photoUrls: [
                    "/detail/photo-1",
                    "/detail/photo-2",
                    "/detail/photo-3"
                ],
                previewPhotoUrls: [
                    "/detail/preview-1",
                    "/detail/preview-2"
                ]
            ),
            relatedMovies: Array(HomeMockData.loadedSections[1].products.prefix(3)),
            countries: [
                PhucTvSimpleLabel(id: 1, name: "United States", link: "us", displayColumn: 1),
                PhucTvSimpleLabel(id: 2, name: "United Kingdom", link: "uk", displayColumn: 1)
            ],
            categories: [
                PhucTvSimpleLabel(id: 10, name: "Sci-Fi", link: "sci-fi", displayColumn: 1),
                PhucTvSimpleLabel(id: 11, name: "Adventure", link: "adventure", displayColumn: 1),
                PhucTvSimpleLabel(id: 12, name: "Drama", link: "drama", displayColumn: 1)
            ],
            episodes: [
                PhucTvMovieEpisode(id: 1, episodeNumber: "1", name: "Episode 1", fullLink: "episode-1", status: "1", type: "sub"),
                PhucTvMovieEpisode(id: 2, episodeNumber: "2", name: "Episode 2", fullLink: "episode-2", status: "1", type: "sub"),
                PhucTvMovieEpisode(id: 3, episodeNumber: "3", name: "Episode 3", fullLink: "episode-3", status: "1", type: "sub")
            ]
        )
    }()

    static let emptyDetail = PhucTvMovieDetail(
        movie: movie,
        relatedMovies: [],
        countries: [],
        categories: [],
        episodes: []
    )
}
