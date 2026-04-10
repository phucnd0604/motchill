import SwiftUI

struct AppShellView: View {
    @State private var path: [AppRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                repository: AppContainer.shared.repository,
                onTapSearch: {
                    path.append(.search)
                },
                onOpenDetail: {
                    path.append(.detail)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .home:
                    HomeView(repository: AppContainer.shared.repository)
                case .search:
                    SearchView()
                case .detail:
                    DetailView()
                case .player:
                    PlayerView()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
