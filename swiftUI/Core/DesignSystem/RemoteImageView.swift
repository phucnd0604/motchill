import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let url: URL?

    var body: some View {
        KFImage(url)
            .placeholder {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.03),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .resizable()
            .scaledToFill()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
