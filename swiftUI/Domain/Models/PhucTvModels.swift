import Foundation

struct PhucTvSearchChoice: Codable, Hashable, Sendable {
    let value: String
    let label: String
}

struct PhucTvSimpleLabel: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let link: String
    let displayColumn: Int
}

struct PhucTvHomeSection: Codable, Hashable, Sendable, Identifiable {
    var id: String {
        key
    }
    let title: String
    let key: String
    let products: [PhucTvMovieCard]
    let isCarousel: Bool
}

struct PhucTvMovieCard: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let otherName: String
    let avatar: String
    let bannerThumb: String
    let avatarThumb: String
    let description: String
    let banner: String
    let imageIcon: String
    let link: String
    let quantity: String
    let rating: String
    let year: Int
    let statusTitle: String
    let statusRaw: String
    let statusText: String
    let director: String
    let time: String
    let trailer: String
    let showTimes: String
    let moreInfo: String
    let castString: String
    let episodesTotal: Int
    let viewNumber: Int
    let ratePoint: Double
    let photoUrls: [String]
    let previewPhotoUrls: [String]

    var displayTitle: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled" : trimmed
    }

    var displaySubtitle: String {
        let other = otherName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !other.isEmpty {
            return other
        }
        return description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var displayPoster: String {
        let thumb = avatarThumb.trimmingCharacters(in: .whitespacesAndNewlines)
        return thumb.isEmpty ? avatar : thumb
    }

    var displayBanner: String {
        let bannerValue = banner.trimmingCharacters(in: .whitespacesAndNewlines)
        return bannerValue.isEmpty ? bannerThumb : bannerValue
    }

    static let empty = PhucTvMovieCard(
        id: 0,
        name: "",
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

struct PhucTvNavbarItem: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let slug: String
    let items: [PhucTvNavbarItem]
    let isExistChild: Bool
}

struct PhucTvPopupAdConfig: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let type: String
    let desktopLink: String
    let mobileLink: String
}

struct PhucTvMovieEpisode: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let episodeNumber: String
    let name: String
    let fullLink: String
    let status: String
    let type: String

    var label: String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            return trimmedName
        }

        let trimmedEpisodeNumber = episodeNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedEpisodeNumber.isEmpty {
            return "Tập \(trimmedEpisodeNumber)"
        }

        return "Episode"
    }
}

struct PhucTvMovieDetail: Codable, Hashable, Sendable {
    let movie: PhucTvMovieCard
    let relatedMovies: [PhucTvMovieCard]
    let countries: [PhucTvSimpleLabel]
    let categories: [PhucTvSimpleLabel]
    let episodes: [PhucTvMovieEpisode]

    var id: Int { movie.id }
    var title: String { movie.name }
    var otherName: String { movie.otherName }
    var avatar: String { movie.avatar }
    var avatarThumb: String { movie.avatarThumb }
    var banner: String { movie.banner }
    var bannerThumb: String { movie.bannerThumb }
    var description: String { movie.description }
    var quality: String { movie.quantity }
    var statusTitle: String { movie.statusTitle }
    var statusRaw: String { movie.statusRaw }
    var statusText: String { movie.statusText }
    var director: String { movie.director }
    var time: String { movie.time }
    var trailer: String { movie.trailer }
    var showTimes: String { movie.showTimes }
    var moreInfo: String { movie.moreInfo }
    var castString: String { movie.castString }
    var year: Int { movie.year }
    var episodesTotal: Int { movie.episodesTotal }
    var viewNumber: Int { movie.viewNumber }
    var ratePoint: Double { movie.ratePoint }
    var photoUrls: [String] { movie.photoUrls }
    var previewPhotoUrls: [String] { movie.previewPhotoUrls }

    var displayBackdrop: String {
        if !movie.banner.isEmpty {
            return movie.banner
        }
        if !movie.avatar.isEmpty {
            return movie.avatar
        }
        if !movie.bannerThumb.isEmpty {
            return movie.bannerThumb
        }
        return movie.avatarThumb
    }
}

struct PhucTvSearchFacetOption: Codable, Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let slug: String

    var hasID: Bool { id > 0 }
}

struct PhucTvSearchFilterData: Codable, Hashable, Sendable {
    let categories: [PhucTvSearchFacetOption]
    let countries: [PhucTvSearchFacetOption]
}

struct PhucTvSearchPagination: Codable, Hashable, Sendable {
    let pageIndex: Int
    let pageSize: Int
    let pageCount: Int
    let totalRecords: Int

    var hasPreviousPage: Bool { pageIndex > 1 }
    var hasNextPage: Bool { pageIndex < pageCount }
}

struct PhucTvSearchResults: Codable, Hashable, Sendable {
    let records: [PhucTvMovieCard]
    let pagination: PhucTvSearchPagination
}

struct PhucTvPlayTrack: Codable, Hashable, Sendable {
    let kind: String
    let file: String
    let label: String
    let isDefault: Bool

    var displayLabel: String {
        let trimmedLabel = label.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedLabel.isEmpty {
            return trimmedLabel
        }

        let trimmedFile = file.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedFile.isEmpty {
            return trimmedFile
        }

        let trimmedKind = kind.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedKind.isEmpty ? "Track" : trimmedKind
    }

    var isAudio: Bool {
        matchesTrackKind(kind, expectedHints: Self.audioKindHints)
    }

    var isSubtitle: Bool {
        matchesTrackKind(kind, expectedHints: Self.subtitleKindHints) || looksLikeSubtitleFile(file)
    }

    private static let audioKindHints = [
        "audio",
        "dub",
        "voice",
        "aac",
        "mp4a",
    ]

    private static let subtitleKindHints = [
        "subtitle",
        "sub",
        "caption",
        "captions",
        "cc",
        "text",
    ]
}

struct PhucTvPlaySource: Codable, Hashable, Identifiable, Sendable {
    let sourceId: Int
    let serverName: String
    let link: String
    let subtitle: String
    let type: Int
    let isFrame: Bool
    let quality: String
    let tracks: [PhucTvPlayTrack]

    var id: Int { sourceId }

    var displayName: String {
        var parts: [String] = []

        let trimmedServerName = serverName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedServerName.isEmpty {
            parts.append(trimmedServerName)
        }

        let trimmedQuality = quality.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedQuality.isEmpty {
            parts.append(trimmedQuality)
        }

        parts.append(isFrame ? "iframe" : "stream")
        return parts.joined(separator: " • ")
    }

    var actionButtonTitle: String {
        let trimmedServerName = serverName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedServerName.isEmpty {
            return trimmedServerName
        }

        return displayName
    }

    var audioTracks: [PhucTvPlayTrack] {
        tracks.filter { $0.isAudio }
    }

    var subtitleTracks: [PhucTvPlayTrack] {
        var explicit = tracks.filter { $0.isSubtitle }
        if explicit.isEmpty {
            let trimmedSubtitle = subtitle.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSubtitle.isEmpty, looksLikeSubtitleFile(trimmedSubtitle) {
                explicit.append(
                    PhucTvPlayTrack(
                        kind: "subtitle",
                        file: trimmedSubtitle,
                        label: "Subtitle",
                        isDefault: true
                    )
                )
            }
        }
        return explicit
    }

    var hasAudioTracks: Bool { !audioTracks.isEmpty }
    var hasSubtitleTracks: Bool { !subtitleTracks.isEmpty }
    var defaultAudioTrack: PhucTvPlayTrack? { audioTracks.first(where: { $0.isDefault }) }
    var defaultSubtitleTrack: PhucTvPlayTrack? { subtitleTracks.first(where: { $0.isDefault }) }
    var isStream: Bool { !isFrame }
}

struct PhucTvPlaybackProgressSnapshot: Codable, Hashable, Sendable {
    let positionMillis: Int64
    let durationMillis: Int64

    var progressFraction: Double {
        guard durationMillis > 0 else { return 0 }
        let fraction = Double(positionMillis) / Double(durationMillis)
        return min(max(fraction, 0), 1)
    }
}

extension Array where Element == PhucTvPlaySource {
    var playableDirectStreams: [PhucTvPlaySource] {
        filter(\.isStream)
    }
}

private func matchesTrackKind(_ kind: String, expected: String) -> Bool {
    kind.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(expected.lowercased())
}

private func matchesTrackKind(_ kind: String, expectedHints: [String]) -> Bool {
    let normalizedKind = kind.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard !normalizedKind.isEmpty else { return false }
    return expectedHints.contains { normalizedKind.contains($0) }
}

private func looksLikeSubtitleFile(_ file: String) -> Bool {
    let extensionValue = file
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: ".")
        .last
        .map(String.init)
        .map { $0.lowercased() } ?? ""

    return [
        "srt",
        "vtt",
        "ass",
        "ssa",
        "sub",
        "ttml",
        "dfxp",
    ].contains(extensionValue)
}
