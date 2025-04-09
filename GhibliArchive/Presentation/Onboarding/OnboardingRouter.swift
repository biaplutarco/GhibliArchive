//
//  OnboardingRouter.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit

protocol OnboardingRouterProtocol {
    var viewController: UIViewController? { get set }

    func continueToFilms()
}

final class OnboardingRouter: OnboardingRouterProtocol {
    weak var viewController: UIViewController?
    
    func continueToFilms() {
        viewController?.dismiss(animated: true)
    }
}
