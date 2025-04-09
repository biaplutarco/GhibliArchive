//
//  OnboardingUserDefaults.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

protocol OnboardingUserDefaultsProtocol {
    func getHasSeenOnboarding() -> Bool
    func setHasSeeOnboarding()
}

final class OnboardingUserDefaults: OnboardingUserDefaultsProtocol {
    private let key = "hasSeenOnboarding"
    private let defaults = UserDefaults.standard
    
    func getHasSeenOnboarding() -> Bool{
        defaults.bool(forKey: key)
    }
    
    func setHasSeeOnboarding() {
        defaults.set(true, forKey: key)
    }
}
