import SwiftUI

struct FeatureStateOverlay: View {
    let descriptor: FeatureOverlayDescriptor
    let actionButtons: [ErrorOverlay.ActionButton]
    let onRetry: () -> Void
    let onSecondary: (() -> Void)?

    init(
        descriptor: FeatureOverlayDescriptor,
        actionButtons: [ErrorOverlay.ActionButton] = [],
        onRetry: @escaping () -> Void,
        onSecondary: (() -> Void)? = nil
    ) {
        self.descriptor = descriptor
        self.actionButtons = actionButtons
        self.onRetry = onRetry
        self.onSecondary = onSecondary
    }

    var body: some View {
        ErrorOverlay(
            title: descriptor.title,
            message: descriptor.message,
            retryTitle: descriptor.retryTitle,
            homeTitle: descriptor.secondaryTitle ?? "Go back",
            errorCode: descriptor.errorCode,
            icon: descriptor.icon,
            isLoading: descriptor.isLoading,
            actionButtons: actionButtons,
            onRetry: onRetry,
            onGoHome: onSecondary
        )
    }
}
