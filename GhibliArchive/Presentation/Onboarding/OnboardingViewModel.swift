//
//  OnboardingViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

// MARK: - Protocol

protocol OnboardingViewModelProtocol {
    var subtitle: String { get }
    var buttonTitle: String { get }
    var title: String { get }
    
    func didSeeOnboarding()
}

// MARK: - Class

final class OnboardingViewModel {
    private let userDefaults: OnboardingUserDefaultsProtocol

    var subtitle: String { Strings.Onboarding.subtitle }
    var buttonTitle: String { Strings.Onboarding.buttonTitle }
    var title: String { Strings.Onboarding.title }
    
    // MARK: - Inits

    init(onboardingUserDefaults: OnboardingUserDefaultsProtocol) {
        self.userDefaults = onboardingUserDefaults
    }
}

// MARK: - Class

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func didSeeOnboarding() {
        userDefaults.setHasSeeOnboarding()
    }
}
