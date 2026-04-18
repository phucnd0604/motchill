import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>

    var body: some View {
        HomeIpadScreen(store: store)
            .ignoresSafeArea()
            .toolbar {
                titleToolbar
                searchToolbar
            }
            .task {
                await store.send(.onTask).finish()
            }
    }

    private var titleToolbar: ToolbarItem<(), some View> {
        ToolbarItem(placement: .title) {
            TabSegmentedView(
                selectedItem: Binding(
                    get: { store.selectedSection },
                    set: { store.send(.sectionSelected($0)) }
                ),
                items: store.sections,
                spacing: 4,
                horizontalPadding: 8
            ) { item, selected in
                Text(item.title)
                    .font(AppTheme.sectionTitleFont.weight(.semibold))
                    .foregroundStyle(selected ? Color(hex: "FFB4AA") : AppTheme.textPrimary)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        Capsule()
                            .fill(selected ? Color.white.opacity(0.2) : Color.clear)
                    )
            }
            .frame(maxWidth: 500)
        }
    }

    private var searchToolbar: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                store.send(.searchTapped)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                    Text("Tìm kiếm")
                }
                .font(AppTheme.bodyFont.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        }
    }
}
