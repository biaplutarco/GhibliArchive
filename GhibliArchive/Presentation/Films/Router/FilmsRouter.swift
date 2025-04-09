//
//  FilmsRouter.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit

// MARK: - Protocol

protocol FilmsRouterProtocol {
    var viewController: UIViewController? { get set }

    func goToFilmDetails(with id: String)
    func goToFavorites()
}

// MARK: - Class

final class FilmsRouter: FilmsRouterProtocol {
    weak var viewController: UIViewController?
    
    func goToFilmDetails(with id: String) {
        let nextViewController = FilmDetailsViewControllerBuilder().build(with: id)
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func goToFavorites() {
        let nextViewController = FavoritesViewControllerBuilder().build()
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
