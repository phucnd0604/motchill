import Foundation

struct PhucTvRemoteConfig: Codable, Equatable {
    let domain: String
    let key: String

    var apiBaseURL: URL? {
        URL(string: domain)
    }

    var isValid: Bool {
        !domain.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && apiBaseURL != nil
    }
}

enum PhucTvRemoteConfigError: Error, LocalizedError {
    case invalidResponse
    case httpStatus(code: Int, url: URL)
    case emptyBody
    case invalidPayload

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The remote config response was invalid."
        case let .httpStatus(code, url):
            return "HTTP \(code) for \(url.absoluteString)"
        case .emptyBody:
            return "The remote config body was empty."
        case .invalidPayload:
            return "The remote config payload was invalid."
        }
    }
}

protocol PhucTvRemoteConfigStoring: AnyObject, Sendable {
    var current: PhucTvRemoteConfig? { get }

    func update(_ config: PhucTvRemoteConfig?)
    func reset()
}

final class PhucTvRemoteConfigStore: PhucTvRemoteConfigStoring, @unchecked Sendable {
    static let shared = PhucTvRemoteConfigStore()

    private let lock = NSLock()
    private var storage: PhucTvRemoteConfig?

    var current: PhucTvRemoteConfig? {
        lock.withLock { storage }
    }

    var apiBaseURL: URL? {
        current?.apiBaseURL
    }

    var passphrase: String? {
        current?.key
    }

    func update(_ config: PhucTvRemoteConfig?) {
        lock.withLock {
            storage = config
        }
    }

    func reset() {
        update(nil)
    }
}

protocol PhucTvRemoteConfigLoading: AnyObject, Sendable {
    func fetchRemoteConfig() async throws -> PhucTvRemoteConfig
}

final class PhucTvRemoteConfigClient: PhucTvRemoteConfigLoading, @unchecked Sendable {
    private let endpoint: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        endpoint: URL = URL(string: "https://gist.githubusercontent.com/phucnd0604/72a74d2e9bfeee2a004400cb5016dac1/raw/")!,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.endpoint = endpoint
        self.session = session
        self.decoder = decoder
    }

    func fetchRemoteConfig() async throws -> PhucTvRemoteConfig {
        let (data, response) = try await session.data(from: endpoint)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PhucTvRemoteConfigError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw PhucTvRemoteConfigError.httpStatus(code: httpResponse.statusCode, url: endpoint)
        }

        let trimmedData = data.trimmingWhitespaceAndNewlines()
        guard !trimmedData.isEmpty else {
            throw PhucTvRemoteConfigError.emptyBody
        }

        let config = try decoder.decode(PhucTvRemoteConfig.self, from: trimmedData)
        guard config.isValid else {
            throw PhucTvRemoteConfigError.invalidPayload
        }

        return config
    }
}

private extension NSLock {
    func withLock<T>(_ body: () -> T) -> T {
        lock()
        defer { unlock() }
        return body()
    }
}

private extension Data {
    func trimmingWhitespaceAndNewlines() -> Data {
        let text = String(decoding: self, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Data(text.utf8)
    }
}
