import AVKit
import SwiftUI

struct PlayerView: View {
    @State private var viewModel: PlayerViewModel
    let router: AppRouter
    private let shouldLoadOnAppear: Bool

    init(
        movieID: Int,
        episodeID: Int,
        movieTitle: String,
        episodeLabel: String,
        repository: MotchillRepository,
        playbackPositionStore: MotchillPlaybackPositionStoring,
        router: AppRouter
    ) {
        _viewModel = State(
            initialValue: PlayerViewModel(
                movieID: movieID,
                episodeID: episodeID,
                movieTitle: movieTitle,
                episodeLabel: episodeLabel,
                repository: repository,
                playbackPositionStore: playbackPositionStore
            )
        )
        self.router = router
        self.shouldLoadOnAppear = true
    }

    init(viewModel: PlayerViewModel, router: AppRouter) {
        _viewModel = State(initialValue: viewModel)
        self.router = router
        self.shouldLoadOnAppear = false
    }

    var body: some View {
        PlayerScreen(viewModel: viewModel, router: router)
            .task {
                guard shouldLoadOnAppear else { return }
                await viewModel.load()
            }
            .onDisappear {
                Task {
                    await viewModel.persistProgress()
                    viewModel.stop()
                }
            }
    }
}

private struct PlayerScreen: View {
    let viewModel: PlayerViewModel
    let router: AppRouter

    var body: some View {
        ZStack {
            PlayerBackground()
                .ignoresSafeArea()

            if let _ = viewModel.selectedSource {
                VideoPlayer(player: viewModel.player)
                    .ignoresSafeArea()
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.12),
                                Color.black.opacity(0.34),
                                Color.black.opacity(0.80)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(alignment: .topLeading) {
                        PlayerTopBar(
                            movieTitle: viewModel.movieTitle,
                            episodeLabel: viewModel.episodeLabel,
                            sourceName: viewModel.sourceTitle,
                            onBack: { router.pop() }
                        )
                    }
                    .overlay(alignment: .bottomLeading) {
                        PlayerControlPanel(
                            viewModel: viewModel,
                            onSelectSource: viewModel.selectSource,
                            onSelectAudioTrack: viewModel.selectAudioTrack,
                            onSelectSubtitleTrack: viewModel.selectSubtitleTrack,
                            onTogglePlayback: viewModel.togglePlayback,
                            onSeekBack: { viewModel.seek(by: -viewModel.seekStepMillis) },
                            onSeekForward: { viewModel.seek(by: viewModel.seekStepMillis) }
                        )
                    }
            } else {
                PlayerLoadingState(
                    title: viewModel.movieTitle,
                    subtitle: viewModel.episodeLabel
                )
            }

            if case let .error(message) = viewModel.state {
                PlayerErrorOverlay(
                    message: message,
                    onRetry: {
                        Task { await viewModel.retry() }
                    },
                    onBack: { router.pop() }
                )
            } else if viewModel.state == .loading && viewModel.sources.isEmpty {
                PlayerLoadingOverlay(
                    title: viewModel.movieTitle,
                    subtitle: viewModel.episodeLabel
                )
            }
        }
    }
}

private struct PlayerTopBar: View {
    let movieTitle: String
    let episodeLabel: String
    let sourceName: String
    let onBack: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            PlayerIconButton(icon: "chevron.left", label: "Back", onTap: onBack)

            VStack(alignment: .leading, spacing: 6) {
                Text(movieTitle)
                    .font(AppTheme.titleFont)
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(episodeLabel)
                        .font(AppTheme.bodyFont)
                        .foregroundStyle(AppTheme.textSecondary)
                    Text("•")
                        .foregroundStyle(AppTheme.textSecondary)
                    Text(sourceName)
                        .font(AppTheme.bodyFont.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 12)
        }
        .padding(20)
    }
}

private struct PlayerControlPanel: View {
    let viewModel: PlayerViewModel
    let onSelectSource: (Int) -> Void
    let onSelectAudioTrack: (MotchillPlayTrack?) -> Void
    let onSelectSubtitleTrack: (MotchillPlayTrack?) -> Void
    let onTogglePlayback: () -> Void
    let onSeekBack: () -> Void
    let onSeekForward: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.movieTitle)
                    .font(AppTheme.sectionTitleFont)
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(2)
                Text(viewModel.episodeLabel)
                    .font(AppTheme.bodyFont)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            if !viewModel.playableSources.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(Array(viewModel.playableSources.enumerated()), id: \.element.id) { index, source in
                            Button(action: { onSelectSource(index) }) {
                                Text(source.displayName)
                                    .font(AppTheme.captionFont.weight(.semibold))
                                    .foregroundStyle(index == viewModel.selectedSourceIndex ? Color.white : AppTheme.textPrimary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(index == viewModel.selectedSourceIndex ? AppTheme.accent.opacity(0.20) : Color.white.opacity(0.05))
                                    )
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .stroke(index == viewModel.selectedSourceIndex ? AppTheme.accent.opacity(0.40) : Color.white.opacity(0.10), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            HStack(spacing: 10) {
                Menu {
                    Button("Auto", action: { onSelectAudioTrack(nil) })
                    ForEach(viewModel.availableAudioTracks, id: \.self) { track in
                        Button(track.displayLabel) { onSelectAudioTrack(track) }
                    }
                } label: {
                    PlayerMenuChip(
                        title: "Audio",
                        value: viewModel.selectedAudioTrack?.displayLabel ?? "Auto"
                    )
                }
                .disabled(viewModel.availableAudioTracks.isEmpty)

                Menu {
                    Button("Off", action: { onSelectSubtitleTrack(nil) })
                    ForEach(viewModel.availableSubtitleTracks, id: \.self) { track in
                        Button(track.displayLabel) { onSelectSubtitleTrack(track) }
                    }
                } label: {
                    PlayerMenuChip(
                        title: "Subtitle",
                        value: viewModel.selectedSubtitleTrack?.displayLabel ?? "Off"
                    )
                }
                .disabled(viewModel.availableSubtitleTracks.isEmpty)
            }

            HStack(spacing: 12) {
                PlayerTransportButton(systemImage: "gobackward.10", label: "Back 10s", onTap: onSeekBack)
                PlayerTransportButton(systemImage: viewModel.isPlaying ? "pause.fill" : "play.fill", label: viewModel.isPlaying ? "Pause" : "Play", filled: true, onTap: onTogglePlayback)
                PlayerTransportButton(systemImage: "goforward.10", label: "Forward 10s", onTap: onSeekForward)

                Spacer(minLength: 12)

                Text("\(formatDuration(viewModel.currentPositionMillis)) / \(formatDuration(viewModel.durationMillis))")
                    .font(AppTheme.captionFont.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)
            }

            ProgressView(value: viewModel.progressFraction)
                .tint(AppTheme.accent)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.38))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

private struct PlayerMenuChip: View {
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(AppTheme.captionFont.weight(.semibold))
                .foregroundStyle(AppTheme.textSecondary)
            Text(value)
                .font(AppTheme.captionFont.weight(.semibold))
                .foregroundStyle(AppTheme.textPrimary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct PlayerTransportButton: View {
    let systemImage: String
    let label: String
    var filled: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(filled ? AppTheme.accent : Color.white.opacity(0.06))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

private struct PlayerBackground: View {
    var body: some View {
        ZStack {
            AppTheme.background

            LinearGradient(
                colors: [
                    Color(red: 0.17, green: 0.10, blue: 0.18).opacity(0.65),
                    .clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [
                    Color(red: 0.92, green: 0.22, blue: 0.26).opacity(0.14),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 560
            )
        }
    }
}

private struct PlayerLoadingState: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppTheme.titleFont)
                .foregroundStyle(AppTheme.textPrimary)
            Text(subtitle)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)
            ProgressView()
                .tint(AppTheme.accent)
        }
        .padding(24)
    }
}

private struct PlayerLoadingOverlay: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProgressView()
                .tint(AppTheme.accent)
            Text("Đang tải player")
                .font(AppTheme.sectionTitleFont)
                .foregroundStyle(AppTheme.textPrimary)
            Text(title)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)
            Text(subtitle)
                .font(AppTheme.captionFont)
                .foregroundStyle(AppTheme.textMuted)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.48))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .padding(24)
    }
}

private struct PlayerErrorOverlay: View {
    let message: String
    let onRetry: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                PlayerIconButton(icon: "chevron.left", label: "Back", onTap: onBack)
                Spacer()
            }

            Text("Không thể mở player")
                .font(AppTheme.titleFont)
                .foregroundStyle(AppTheme.textPrimary)

            Text(message)
                .font(AppTheme.bodyFont)
                .foregroundStyle(AppTheme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: onRetry) {
                Text("Thử lại")
                    .font(AppTheme.bodyFont.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.06))
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.44))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.10), lineWidth: 1)
        )
        .padding(24)
    }
}

private struct PlayerIconButton: View {
    let icon: String
    let label: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(10)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.36))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

private func formatDuration(_ positionMs: Int64) -> String {
    let totalSeconds = max(positionMs, 0) / 1000
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60
    if hours > 0 {
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview("Player") {
    NavigationStack {
        PlayerView(
            viewModel: PlayerViewModel.previewLoaded(),
            router: AppRouter()
        )
    }
}
