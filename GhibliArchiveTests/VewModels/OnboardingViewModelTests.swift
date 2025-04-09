//
//  OnboardingViewModelTests.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import XCTest
@testable import GhibliArchive

final class OnboardingViewModelTests: XCTestCase {

    func makeSut(
        userDefaults: OnboardingUserDefaultsProtocol = SpyOnboardingUserDefaults()
    ) -> OnboardingViewModel {
        return .init(onboardingUserDefaults: userDefaults)
    }

    func test_didSeeOnboarding_shouldCallUserDefaultsMethod() {
        let mockUserDefaults = SpyOnboardingUserDefaults()
        let sut = makeSut(userDefaults: mockUserDefaults)

        sut.didSeeOnboarding()

        XCTAssertTrue(mockUserDefaults.didSeeOnboardingCalled)
    }
}
