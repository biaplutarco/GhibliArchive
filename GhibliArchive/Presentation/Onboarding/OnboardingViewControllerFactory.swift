//
//  OnboardingViewControllerFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

final class OnboardingViewControllerFactory {
    static func make() -> OnboardingHostingController {
        let userDefaults = OnboardingUserDefaults()
        let viewModel = OnboardingViewModel(onboardingUserDefaults: userDefaults)
        let router = OnboardingRouter()
        let viewController = OnboardingHostingController(router: router, viewModel: viewModel)
        router.viewController = viewController
        return viewController
    }
}
