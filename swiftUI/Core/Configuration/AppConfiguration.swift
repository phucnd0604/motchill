import Foundation
import UIKit

struct AppConfiguration {
    let appName: String = "PhucTv"
    private let remoteConfigStore: PhucTvRemoteConfigStoring

    init(remoteConfigStore: PhucTvRemoteConfigStoring = PhucTvRemoteConfigStore.shared) {
        self.remoteConfigStore = remoteConfigStore
    }

    var apiBaseURL: URL? {
        remoteConfigStore.current?.apiBaseURL
    }

    var passphrase: String? {
        remoteConfigStore.current?.key
    }

    let minimumIOSVersion: String = "18.0"
    let requestTimeout: TimeInterval = 20
    @MainActor
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    var requestHeaders: [String: String] {
        [
            "User-Agent": "Mozilla/5.0 (PhucTvSwiftUI)",
            "Accept": "application/json,text/plain,*/*",
        ]
    }
}
