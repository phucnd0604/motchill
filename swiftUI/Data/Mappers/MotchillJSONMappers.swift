import Foundation

struct MotchillHomeSectionDTO: Decodable, Sendable {
    let title: String
    let key: String
    let products: [MotchillMovieCardDTO]
    let isCarousel: Bool

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case key = "Key"
        case products = "Products"
        case isCarousel = "IsCarousel"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeString(forKey: .title)
        key = try container.decodeString(forKey: .key)
        products = try container.decodeIfPresent([MotchillMovieCardDTO].self, forKey: .products) ?? []
        isCarousel = try container.decodeBool(forKey: .isCarousel)
    }
}

struct MotchillMovieCardDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let otherName: String
    let avatar: String
    let bannerThumb: String
    let avatarThumb: String
    let descriptionText: String
    let banner: String
    let imageIcon: String
    let link: String
    let quality: String
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

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case otherName = "OtherName"
        case avatar = "Avatar"
        case bannerThumb = "BannerThumb"
        case avatarThumb = "AvatarThumb"
        case descriptionText = "Description"
        case banner = "Banner"
        case imageIcon = "ImageIcon"
        case link = "Link"
        case quality = "Quanlity"
        case rating = "Rating"
        case year = "Year"
        case statusTitle = "StatusTitle"
        case statusRaw = "StatusRaw"
        case statusText = "StatusTMText"
        case director = "Director"
        case time = "Time"
        case trailer = "Trailer"
        case showTimes = "ShowTimes"
        case moreInfo = "MoreInfo"
        case castString = "CastString"
        case episodesTotal = "EpisodesTotal"
        case viewNumber = "ViewNumber"
        case ratePoint = "RatePoint"
        case photoUrls = "Photos"
        case previewPhotoUrls = "PreviewPhotos"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        name = try container.decodeString(forKey: .name)
        otherName = try container.decodeString(forKey: .otherName)
        avatar = try container.decodeString(forKey: .avatar)
        bannerThumb = try container.decodeString(forKey: .bannerThumb)
        avatarThumb = try container.decodeString(forKey: .avatarThumb)
        descriptionText = try container.decodeString(forKey: .descriptionText)
        banner = try container.decodeString(forKey: .banner)
        imageIcon = try container.decodeString(forKey: .imageIcon)
        link = try container.decodeString(forKey: .link)
        quality = try container.decodeString(forKey: .quality)
        rating = try container.decodeString(forKey: .rating)
        year = try container.decodeInt(forKey: .year)
        statusTitle = try container.decodeString(forKey: .statusTitle)
        statusRaw = try container.decodeString(forKey: .statusRaw)
        statusText = try container.decodeString(forKey: .statusText)
        director = try container.decodeString(forKey: .director)
        time = try container.decodeString(forKey: .time)
        trailer = try container.decodeString(forKey: .trailer)
        showTimes = try container.decodeString(forKey: .showTimes)
        moreInfo = try container.decodeString(forKey: .moreInfo)
        castString = try container.decodeString(forKey: .castString)
        episodesTotal = try container.decodeInt(forKey: .episodesTotal)
        viewNumber = try container.decodeInt(forKey: .viewNumber)
        ratePoint = try container.decodeDouble(forKey: .ratePoint)
        photoUrls = try container.decodeIfPresent([String].self, forKey: .photoUrls) ?? []
        previewPhotoUrls = try container.decodeIfPresent([String].self, forKey: .previewPhotoUrls) ?? []
    }
}

struct MotchillNavbarItemDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let slug: String
    let items: [MotchillNavbarItemDTO]
    let isExistChild: Bool

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case slug = "Slug"
        case items = "Items"
        case isExistChild = "IsExistChild"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        name = try container.decodeString(forKey: .name)
        slug = try container.decodeString(forKey: .slug)
        items = try container.decodeIfPresent([MotchillNavbarItemDTO].self, forKey: .items) ?? []
        isExistChild = try container.decodeBool(forKey: .isExistChild)
    }
}

struct MotchillPopupAdConfigDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let type: String
    let desktopLink: String
    let mobileLink: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case type = "Type"
        case desktopLink = "DesktopLink"
        case mobileLink = "MobileLink"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        name = try container.decodeString(forKey: .name)
        type = try container.decodeString(forKey: .type)
        desktopLink = try container.decodeString(forKey: .desktopLink)
        mobileLink = try container.decodeString(forKey: .mobileLink)
    }
}

struct MotchillSimpleLabelDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let link: String
    let displayColumn: Int

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case link = "Link"
        case displayColumn = "DisplayColumn"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        name = try container.decodeString(forKey: .name)
        link = try container.decodeString(forKey: .link)
        displayColumn = try container.decodeInt(forKey: .displayColumn)
    }
}

struct MotchillMovieEpisodeDTO: Decodable, Sendable {
    let id: Int
    let episodeNumber: String
    let name: String
    let fullLink: String
    let status: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case episodeNumber = "EpisodeNumber"
        case name = "Name"
        case fullLink = "FullLink"
        case status = "Status"
        case type = "Type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        episodeNumber = try container.decodeString(forKey: .episodeNumber)
        name = try container.decodeString(forKey: .name)
        fullLink = try container.decodeString(forKey: .fullLink)
        status = try container.decodeString(forKey: .status)
        type = try container.decodeString(forKey: .type)
    }
}

struct MotchillMovieDetailDTO: Decodable, Sendable {
    let movie: MotchillMovieCardDTO
    let relatedMovies: [MotchillMovieCardDTO]
    let countries: [MotchillSimpleLabelDTO]
    let categories: [MotchillSimpleLabelDTO]
    let episodes: [MotchillMovieEpisodeDTO]

    enum CodingKeys: String, CodingKey {
        case movie
        case relatedMovies
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        movie = try container.decode(MotchillMovieCardDTO.self, forKey: .movie)
        relatedMovies = try container.decodeIfPresent([MotchillMovieCardDTO].self, forKey: .relatedMovies) ?? []

        let movieContainer = try container.nestedContainer(keyedBy: MovieCodingKeys.self, forKey: .movie)
        countries = try movieContainer.decodeIfPresent([MotchillSimpleLabelDTO].self, forKey: .countries) ?? []
        categories = try movieContainer.decodeIfPresent([MotchillSimpleLabelDTO].self, forKey: .categories) ?? []
        episodes = try movieContainer.decodeIfPresent([MotchillMovieEpisodeDTO].self, forKey: .episodes) ?? []
    }

    private enum MovieCodingKeys: String, CodingKey {
        case countries = "Countries"
        case categories = "Categories"
        case episodes = "Episodes"
    }
}

struct MotchillSearchFacetOptionDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let slug: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case slug = "Slug"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        name = try container.decodeString(forKey: .name)
        slug = try container.decodeString(forKey: .slug)
    }
}

struct MotchillSearchFilterDataDTO: Decodable, Sendable {
    let categories: [MotchillSearchFacetOptionDTO]
    let countries: [MotchillSearchFacetOptionDTO]

    enum CodingKeys: String, CodingKey {
        case categories
        case countries
    }
}

struct MotchillSearchPaginationDTO: Decodable, Sendable {
    let pageIndex: Int
    let pageSize: Int
    let pageCount: Int
    let totalRecords: Int

    enum CodingKeys: String, CodingKey {
        case pageIndex = "PageIndex"
        case pageSize = "PageSize"
        case pageCount = "PageCount"
        case totalRecords = "TotalRecords"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageIndex = try container.decodeInt(forKey: .pageIndex)
        pageSize = try container.decodeInt(forKey: .pageSize)
        pageCount = try container.decodeInt(forKey: .pageCount)
        totalRecords = try container.decodeInt(forKey: .totalRecords)
    }
}

struct MotchillSearchResultsDTO: Decodable, Sendable {
    let records: [MotchillMovieCardDTO]
    let pagination: MotchillSearchPaginationDTO

    enum CodingKeys: String, CodingKey {
        case records = "Records"
        case pagination = "Pagination"
    }
}

struct MotchillPlayTrackDTO: Decodable, Sendable {
    let kind: String
    let file: String
    let label: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case kind
        case file
        case label
        case isDefault = "default"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decodeString(forKey: .kind)
        file = try container.decodeString(forKey: .file)
        label = try container.decodeString(forKey: .label)
        isDefault = try container.decodeBool(forKey: .isDefault)
    }
}

struct MotchillPlaySourceDTO: Decodable, Sendable {
    let sourceId: Int
    let serverName: String
    let link: String
    let subtitle: String
    let type: Int
    let isFrame: Bool
    let quality: String
    let tracks: [MotchillPlayTrackDTO]

    enum CodingKeys: String, CodingKey {
        case sourceId = "SourceId"
        case serverName = "ServerName"
        case link = "Link"
        case subtitle = "Subtitle"
        case type = "Type"
        case isFrame = "IsFrame"
        case quality = "Quality"
        case tracks = "Tracks"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceId = try container.decodeInt(forKey: .sourceId)
        serverName = try container.decodeString(forKey: .serverName)
        link = try container.decodeString(forKey: .link)
        subtitle = try container.decodeString(forKey: .subtitle)
        type = try container.decodeInt(forKey: .type)
        isFrame = try container.decodeBool(forKey: .isFrame)
        quality = try container.decodeString(forKey: .quality)
        tracks = try container.decodeIfPresent([MotchillPlayTrackDTO].self, forKey: .tracks) ?? []
    }
}

extension MotchillHomeSectionDTO {
    var domain: MotchillHomeSection {
        MotchillHomeSection(
            title: title,
            key: key,
            products: products.map(\.domain),
            isCarousel: isCarousel
        )
    }
}

extension MotchillMovieCardDTO {
    var domain: MotchillMovieCard {
        MotchillMovieCard(
            id: id,
            name: name,
            otherName: otherName,
            avatar: avatar,
            bannerThumb: bannerThumb,
            avatarThumb: avatarThumb,
            description: descriptionText,
            banner: banner,
            imageIcon: imageIcon,
            link: link,
            quantity: quality,
            rating: rating,
            year: year,
            statusTitle: statusTitle,
            statusRaw: statusRaw,
            statusText: statusText,
            director: director,
            time: time,
            trailer: trailer,
            showTimes: showTimes,
            moreInfo: moreInfo,
            castString: castString,
            episodesTotal: episodesTotal,
            viewNumber: viewNumber,
            ratePoint: ratePoint,
            photoUrls: photoUrls,
            previewPhotoUrls: previewPhotoUrls
        )
    }
}

extension MotchillNavbarItemDTO {
    var domain: MotchillNavbarItem {
        MotchillNavbarItem(
            id: id,
            name: name,
            slug: slug,
            items: items.map(\.domain),
            isExistChild: isExistChild
        )
    }
}

extension MotchillPopupAdConfigDTO {
    var domain: MotchillPopupAdConfig {
        MotchillPopupAdConfig(
            id: id,
            name: name,
            type: type,
            desktopLink: desktopLink,
            mobileLink: mobileLink
        )
    }
}

extension MotchillSimpleLabelDTO {
    var domain: MotchillSimpleLabel {
        MotchillSimpleLabel(
            id: id,
            name: name,
            link: link,
            displayColumn: displayColumn
        )
    }
}

extension MotchillMovieEpisodeDTO {
    var domain: MotchillMovieEpisode {
        MotchillMovieEpisode(
            id: id,
            episodeNumber: episodeNumber,
            name: name,
            fullLink: fullLink,
            status: status,
            type: type
        )
    }
}

extension MotchillMovieDetailDTO {
    var domain: MotchillMovieDetail {
        MotchillMovieDetail(
            movie: movie.domain,
            relatedMovies: relatedMovies.map(\.domain),
            countries: countries.map(\.domain),
            categories: categories.map(\.domain),
            episodes: episodes.map(\.domain)
        )
    }
}

extension MotchillSearchFacetOptionDTO {
    var domain: MotchillSearchFacetOption {
        MotchillSearchFacetOption(id: id, name: name, slug: slug)
    }
}

extension MotchillSearchFilterDataDTO {
    var domain: MotchillSearchFilterData {
        MotchillSearchFilterData(
            categories: categories.map(\.domain),
            countries: countries.map(\.domain)
        )
    }
}

extension MotchillSearchPaginationDTO {
    var domain: MotchillSearchPagination {
        MotchillSearchPagination(
            pageIndex: pageIndex,
            pageSize: pageSize,
            pageCount: pageCount,
            totalRecords: totalRecords
        )
    }
}

extension MotchillSearchResultsDTO {
    var domain: MotchillSearchResults {
        MotchillSearchResults(
            records: records.map(\.domain),
            pagination: pagination.domain
        )
    }
}

extension MotchillPlayTrackDTO {
    var domain: MotchillPlayTrack {
        MotchillPlayTrack(kind: kind, file: file, label: label, isDefault: isDefault)
    }
}

extension MotchillPlaySourceDTO {
    var domain: MotchillPlaySource {
        MotchillPlaySource(
            sourceId: sourceId,
            serverName: serverName,
            link: link,
            subtitle: subtitle,
            type: type,
            isFrame: isFrame,
            quality: quality,
            tracks: tracks.map(\.domain)
        )
    }
}

private extension KeyedDecodingContainer {
    func decodeString(forKey key: Key) throws -> String {
        if let value = try? decode(String.self, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Double.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Bool.self, forKey: key) {
            return value ? "true" : "false"
        }
        return ""
    }

    func decodeInt(forKey key: Key) throws -> Int {
        if let value = try? decode(Int.self, forKey: key) {
            return value
        }
        if let value = try? decode(Double.self, forKey: key) {
            return Int(value)
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        }
        if let value = try? decode(Bool.self, forKey: key) {
            return value ? 1 : 0
        }
        return 0
    }

    func decodeDouble(forKey key: Key) throws -> Double {
        if let value = try decodeIfPresent(Double.self, forKey: key) {
            return value
        }
        if let value = try decodeIfPresent(Int.self, forKey: key) {
            return Double(value)
        }
        if let value = try decodeIfPresent(String.self, forKey: key) {
            return Double(value.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        }
        if let value = try decodeIfPresent(Bool.self, forKey: key) {
            return value ? 1 : 0
        }
        return 0
    }

    func decodeBool(forKey key: Key) throws -> Bool {
        if let value = try decodeIfPresent(Bool.self, forKey: key) {
            return value
        }
        if let value = try decodeIfPresent(Int.self, forKey: key) {
            return value != 0
        }
        if let value = try decodeIfPresent(Double.self, forKey: key) {
            return value != 0
        }
        if let value = try decodeIfPresent(String.self, forKey: key) {
            let normalized = value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            switch normalized {
            case "true", "1", "yes", "y":
                return true
            case "false", "0", "no", "n", "":
                return false
            default:
                return Bool(normalized) ?? false
            }
        }
        return false
    }
}
