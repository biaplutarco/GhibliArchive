//
//  OnboardingHostingController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit
import SwiftUI

final class OnboardingHostingController: UIHostingController<OnboardingView> {
    private let viewModel: OnboardingViewModelProtocol
    
    init(router: OnboardingRouterProtocol, viewModel: OnboardingViewModelProtocol) {
        self.viewModel = viewModel
        
        let onboardingView = OnboardingView(onContinue: {
            router.continueToFilms()
        }, viewModel: viewModel)
        
        super.init(rootView: onboardingView)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.didSeeOnboarding()
    }
}
