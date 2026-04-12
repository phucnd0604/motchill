//
//  ScreenIdeManager.swift
//  PhucTvSwiftUI
//
//  Created by Phucnd on 12/4/26.
//  Copyright © 2026 PhucTv. All rights reserved.
//

import UIKit

@MainActor
final class ScreenIdeManager {
    static let shared = ScreenIdeManager()
    
    private var activeRequestCount = 0
    
    private init() {}
    
    func disableAutoLock() {
        activeRequestCount += 1
        applyIdleTimerState()
    }
    
    func enableAutoLock() {
        activeRequestCount = max(0, activeRequestCount - 1)
        applyIdleTimerState()
    }
    
    func reset() {
        activeRequestCount = 0
        applyIdleTimerState()
    }
    
    private func applyIdleTimerState() {
        UIApplication.shared.isIdleTimerDisabled = activeRequestCount > 0
    }
}
