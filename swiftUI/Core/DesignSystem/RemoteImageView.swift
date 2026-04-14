import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let url: URL?
    var cornerRadius: CGFloat = 24
    var width: CGFloat? = nil
    var height: CGFloat? = nil

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
            .frame(width: width, height: height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
