import Foundation

struct PhucTvSupabaseConfiguration: Sendable {
    let url: URL
    let publishableKey: String

    init?(configuration: AppConfiguration) {
        guard let url = configuration.supabaseURL,
              let publishableKey = configuration.supabasePublishableKey
        else {
            return nil
        }
        self.url = url
        self.publishableKey = publishableKey
    }
}
