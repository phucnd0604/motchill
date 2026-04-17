//
//  LoadingIndicator.swift
//  PhucTvSwiftUI
//
//  Created by Phucnd on 17/4/26.
//  Copyright © 2026 PhucTv. All rights reserved.
//
import SwiftUI
import DotLottie

struct LoadingIndicatorViewModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Color.clear.opacity(0.4)
                    .ignoresSafeArea()
                DotLottieAnimation(
                    fileName: "Success_Send",
                    config: AnimationConfig(autoplay: true, loop: true)
                )
                .view()
            }
        }
    }
}

extension View {
    func loadingIndicator(_ isLoading: Bool) -> some View {
        self.modifier(LoadingIndicatorViewModifier(isLoading: isLoading))
    }
}
