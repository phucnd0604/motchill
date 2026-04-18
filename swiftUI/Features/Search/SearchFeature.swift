import ComposableArchitecture
import SwiftUI

@Reducer
struct SearchFeature {
    @ObservableState
    struct State: Equatable {
        var title = "Search"
        var subtitle = "Placeholder screen for phase 2"
        var bodyText = "The real search view model will be mapped here in a later phase."
    }

    @CasePathable
    enum Action: Equatable {
        case backButtonTapped
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

struct SearchFeatureView: View {
    @Bindable var store: StoreOf<SearchFeature>

    var body: some View {
        PlaceholderFeatureScreen(
            title: store.title,
            subtitle: store.subtitle,
            description: store.bodyText,
            backTitle: "Quay lại",
            systemImage: "magnifyingglass",
            onBack: { store.send(.backButtonTapped) }
        )
    }
}
