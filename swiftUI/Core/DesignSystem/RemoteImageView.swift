import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let url: URL?
    var cornerRadius: CGFloat = 24

    var body: some View {
        KFImage(url)
            .placeholder {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundStyle(AppTheme.accent.opacity(0.6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .resizable()
            .scaledToFill()
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
