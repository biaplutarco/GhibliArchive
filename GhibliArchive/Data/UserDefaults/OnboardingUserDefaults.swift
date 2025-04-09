//
//  OnboardingUserDefaults.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

protocol OnboardingUserDefaultsProtocol {
    func hasSeenOnboarding() -> Bool
    func didSeeOnboarding()
}

final class OnboardingUserDefaults: OnboardingUserDefaultsProtocol {
    private let key = "hasSeenOnboarding"
    private let defaults = UserDefaults.standard
    
    func hasSeenOnboarding() -> Bool{
        defaults.bool(forKey: key)
    }
    
    func didSeeOnboarding() {
        defaults.set(true, forKey: key)
    }
}
