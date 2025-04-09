//
//  FavoritesViewControllerFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

final class FavoritesViewControllerFactory {
    static func make() -> FavoritesViewController {
        let service = NetworkService()
        let cacheService = ImageCacheService()
        let userDefaults = FilmUserDefaults()
        let favoritesUseCase = FavoritesFilmUseCase(userDefaults: userDefaults)
        let imageUseCase = ImageLoaderUseCase(networkService: service, cacheService: cacheService)
        let viewModel = FavoritesViewModel(favoritesUseCase: favoritesUseCase, imageLoaderUseCase: imageUseCase)
        let router = FavoritesRouter()
        let viewController = FavoritesViewController(viewModel: viewModel, router: router)
        router.viewController = viewController
        return viewController
    }
}
