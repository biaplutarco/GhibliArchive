//
//  SpyOnboardingUserDefaults.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Foundation

final class SpyOnboardingUserDefaults: OnboardingUserDefaultsProtocol {
    private(set) var didSeeOnboardingCalled = false

    func didSeeOnboarding() {
        didSeeOnboardingCalled = true
    }
}
