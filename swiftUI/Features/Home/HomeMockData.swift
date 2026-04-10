import Foundation

enum HomeMockData {
    static let loadedSections: [MotchillHomeSection] = [
        section(
            title: "Slide",
            key: "slide",
            movies: [
                movie(
                    id: 1,
                    name: "Dune: Part Two",
                    otherName: "2024",
                    description: "A war of bloodlines and prophecy pushes the desert planet into a new era of power.",
                    banner: "/home/slide-banner-1",
                    avatar: "/home/slide-avatar-1",
                    rating: "8.8",
                    year: 2024,
                    statusTitle: "Featured",
                    quality: "4K"
                ),
                movie(
                    id: 2,
                    name: "Oppenheimer",
                    otherName: "2023",
                    description: "The story of the physicist behind the atomic age and the moral cost that followed.",
                    banner: "/home/slide-banner-2",
                    avatar: "/home/slide-avatar-2",
                    rating: "8.6",
                    year: 2023,
                    statusTitle: "Trending",
                    quality: "4K"
                ),
                movie(
                    id: 3,
                    name: "The Batman",
                    otherName: "2022",
                    description: "A vigilante chases a hidden conspiracy through Gotham's rain-soaked underworld.",
                    banner: "/home/slide-banner-3",
                    avatar: "/home/slide-avatar-3",
                    rating: "8.0",
                    year: 2022,
                    statusTitle: "Popular",
                    quality: "HD"
                ),
                movie(
                    id: 4,
                    name: "Arrival",
                    otherName: "2016",
                    description: "A linguist tries to understand a message from visitors before the world fractures.",
                    banner: "/home/slide-banner-4",
                    avatar: "/home/slide-avatar-4",
                    rating: "7.9",
                    year: 2016,
                    statusTitle: "Classic",
                    quality: "HD"
                ),
                movie(
                    id: 5,
                    name: "Spider-Man: Across the Spider-Verse",
                    otherName: "2023",
                    description: "Miles crosses dimensions again while a bigger multiverse conflict closes in.",
                    banner: "/home/slide-banner-5",
                    avatar: "/home/slide-avatar-5",
                    rating: "8.7",
                    year: 2023,
                    statusTitle: "Top pick",
                    quality: "4K"
                ),
                movie(
                    id: 6,
                    name: "Top Gun: Maverick",
                    otherName: "2022",
                    description: "A veteran pilot returns to train the next generation for an impossible mission.",
                    banner: "/home/slide-banner-6",
                    avatar: "/home/slide-avatar-6",
                    rating: "8.3",
                    year: 2022,
                    statusTitle: "Action",
                    quality: "4K"
                )
            ]
        ),
        section(
            title: "Mới và nổi bật",
            key: "featured",
            movies: [
                movie(
                    id: 101,
                    name: "A Quiet Signal",
                    otherName: "Drama • 2026",
                    description: "A suspenseful feature built around a disappearing broadcast and a family that keeps hearing the same signal.",
                    banner: "/home/featured-banner-1",
                    avatar: "/home/featured-avatar-1",
                    rating: "8.8",
                    year: 2026,
                    statusTitle: "Now showing",
                    quality: "4K"
                ),
                movie(
                    id: 102,
                    name: "After the Rain",
                    otherName: "Romance • Limited series",
                    description: "Two people reconnect through a city-wide blackout and the cassette tape that starts everything again.",
                    banner: "/home/featured-banner-2",
                    avatar: "/home/featured-avatar-2",
                    rating: "8.3",
                    year: 2025,
                    statusTitle: "Trending",
                    quality: "HD"
                ),
                movie(
                    id: 103,
                    name: "Neon Harbor",
                    otherName: "Sci-Fi • Action",
                    description: "An ex-courier races through a flooded metro to protect the last map of the old city.",
                    banner: "/home/featured-banner-3",
                    avatar: "/home/featured-avatar-3",
                    rating: "9.1",
                    year: 2025,
                    statusTitle: "Hot",
                    quality: "4K"
                )
            ]
        ),
        section(
            title: "Đang thịnh hành",
            key: "trending",
            movies: [
                movie(
                    id: 201,
                    name: "Winter Glass",
                    otherName: "Mystery • 6 episodes",
                    description: "An architect finds hidden rooms inside an apartment block that should not exist.",
                    banner: "/home/trending-banner-1",
                    avatar: "/home/trending-avatar-1",
                    rating: "8.4",
                    year: 2024,
                    statusTitle: "Series",
                    quality: "HD"
                ),
                movie(
                    id: 202,
                    name: "Signal Lost",
                    otherName: "Thriller • 2024",
                    description: "A rescue pilot traces a missing flight using only fragments of a broken radio transmission.",
                    banner: "/home/trending-banner-2",
                    avatar: "/home/trending-avatar-2",
                    rating: "8.0",
                    year: 2024,
                    statusTitle: "Completed",
                    quality: "Full HD"
                ),
                movie(
                    id: 203,
                    name: "Paper Moon City",
                    otherName: "Animation • Family",
                    description: "A child builds a city of paper, then discovers it has its own weather system.",
                    banner: "/home/trending-banner-3",
                    avatar: "/home/trending-avatar-3",
                    rating: "8.7",
                    year: 2023,
                    statusTitle: "Popular",
                    quality: "HD"
                ),
                movie(
                    id: 204,
                    name: "Harbor Lights",
                    otherName: "Crime drama",
                    description: "A night ferry crew becomes the only witness to a perfect disappearance.",
                    banner: "/home/trending-banner-4",
                    avatar: "/home/trending-avatar-4",
                    rating: "7.9",
                    year: 2022,
                    statusTitle: "Series",
                    quality: "HD"
                )
            ]
        ),
        section(
            title: "Gợi ý cho bạn",
            key: "recommended",
            movies: [
                movie(
                    id: 301,
                    name: "Blue Minute",
                    otherName: "Slice of life",
                    description: "A gentle city film about small choices and the people who keep showing up.",
                    banner: "/home/recommended-banner-1",
                    avatar: "/home/recommended-avatar-1",
                    rating: "8.2",
                    year: 2026,
                    statusTitle: "New",
                    quality: "HD"
                ),
                movie(
                    id: 302,
                    name: "Glass District",
                    otherName: "Action • Heist",
                    description: "A crew of former rivals plans one last job beneath a city of mirrored towers.",
                    banner: "/home/recommended-banner-2",
                    avatar: "/home/recommended-avatar-2",
                    rating: "8.9",
                    year: 2025,
                    statusTitle: "Popular",
                    quality: "4K"
                )
            ]
        )
    ]

    static let emptySections: [MotchillHomeSection] = []

    static func section(title: String, key: String, movies: [MotchillMovieCard]) -> MotchillHomeSection {
        MotchillHomeSection(
            title: title,
            key: key,
            products: movies,
            isCarousel: true
        )
    }

    static func movie(
        id: Int,
        name: String,
        otherName: String,
        description: String,
        banner: String,
        avatar: String,
        rating: String,
        year: Int,
        statusTitle: String,
        quality: String
    ) -> MotchillMovieCard {
        MotchillMovieCard(
            id: id,
            name: name,
            otherName: otherName,
            avatar: avatar,
            bannerThumb: banner,
            avatarThumb: avatar,
            description: description,
            banner: banner,
            imageIcon: "",
            link: "/movie/\(id)",
            quantity: quality,
            rating: rating,
            year: year,
            statusTitle: statusTitle,
            statusRaw: statusTitle.lowercased(),
            statusText: statusTitle,
            director: "",
            time: "120m",
            trailer: "",
            showTimes: "",
            moreInfo: description,
            castString: "",
            episodesTotal: 1,
            viewNumber: 0,
            ratePoint: Double(rating) ?? 0,
            photoUrls: [],
            previewPhotoUrls: []
        )
    }
}
