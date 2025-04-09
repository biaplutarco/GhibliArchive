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

    var subtitle: String { """
Discover the magic of Studio Ghibli like never before. Browse through a complete archive of Ghibli films, track the ones you’ve watched, and get to know more about these amazing studio!

Ready to dive into a world of wonder?
"""}
    var buttonTitle: String { "Explore Ghibli Archive" }
    var title: String { "Welcome to Ghibli Archive"}
    
    // MARK: - Inits

    init(onboardingUserDefaults: OnboardingUserDefaultsProtocol) {
        self.userDefaults = onboardingUserDefaults
    }
}

// MARK: - Class

extension OnboardingViewModel: OnboardingViewModelProtocol {
    func didSeeOnboarding() {
        userDefaults.didSeeOnboarding()
    }
    
    
}
