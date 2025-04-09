//
//  OnboardingViewControllerBuilder.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

final class OnboardingViewControllerBuilder {
    private let userDefaults: OnboardingUserDefaultsProtocol
    
    init(userDefaults: OnboardingUserDefaultsProtocol = OnboardingUserDefaults()) {
        self.userDefaults = userDefaults
    }
    
    func build() -> OnboardingHostingController {
        let viewModel = OnboardingViewModel(onboardingUserDefaults: userDefaults)
        let router = OnboardingRouter()
        let viewController = OnboardingHostingController(router: router, viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
