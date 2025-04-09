//
//  FavoritesRouter.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit

// MARK: - Protocol

protocol FavoritesRouterProtocol {
    var viewController: UIViewController? { get set }

    func goToFilmDetails(with id: String)
    func goBack()
}

// MARK: - Class

final class FavoritesRouter: FavoritesRouterProtocol {
    weak var viewController: UIViewController?
    
    func goToFilmDetails(with id: String) {
        let nextViewController = FilmDetailsViewControllerBuilder().build(with: id)
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func goBack() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
