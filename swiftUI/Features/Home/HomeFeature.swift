import ComposableArchitecture
import SwiftUI

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var title = "PhucTv SwiftUI"
        var subtitle = "Navigation shell placeholder"
        var bodyText = "Phase 2 wires the app shell into TCA. Feature logic will be mapped in later phases."
    }

    @CasePathable
    enum Action: Equatable {
        case searchTapped
        case detailTapped
        case playerTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

struct HomeFeatureView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.09, green: 0.10, blue: 0.14),
                    Color(red: 0.14, green: 0.09, blue: 0.17),
                    Color(red: 0.05, green: 0.05, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                header
                buttons
            }
            .frame(maxWidth: 560)
            .padding(.horizontal, 20)
            .padding(.vertical, 32)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(store.subtitle)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.82))

            Text(store.bodyText)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var buttons: some View {
        VStack(spacing: 12) {
            Button {
                store.send(.searchTapped)
            } label: {
                label("Open Search", systemImage: "magnifyingglass")
            }

            Button {
                store.send(.detailTapped)
            } label: {
                label("Open Detail", systemImage: "film")
            }

            Button {
                store.send(.playerTapped)
            } label: {
                label("Open Player", systemImage: "play.fill")
            }
        }
    }

    private func label(_ title: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(title)
                .fontWeight(.semibold)
            Spacer(minLength: 0)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}
