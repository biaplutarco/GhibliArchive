//
//  SpyOnboardingUserDefaults.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Foundation
@testable import GhibliArchive

final class SpyOnboardingUserDefaults: OnboardingUserDefaultsProtocol {
    private(set) var didSeeOnboardingCalled = false
    private(set) var hasSeenOnboardingCalled = false

    func didSeeOnboarding() {
        didSeeOnboardingCalled = true
    }
    
    func hasSeenOnboarding() -> Bool {
        hasSeenOnboardingCalled = true
        return false
    }
}
