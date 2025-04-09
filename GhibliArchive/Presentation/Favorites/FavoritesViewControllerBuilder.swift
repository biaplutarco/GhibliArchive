//
//  FavoritesViewControllerBuilder.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

final class FavoritesViewControllerBuilder {
    private let networkService: NetworkServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    private let userDefaults: FilmUserDefaultsProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        imageCacheService: ImageCacheServiceProtocol = ImageCacheService(),
        userDefaults: FilmUserDefaultsProtocol = FilmUserDefaults()
    ) {
        self.networkService = networkService
        self.imageCacheService = imageCacheService
        self.userDefaults = userDefaults
    }
    
    func build() -> FavoritesViewController {
        let filmsNetworkService = FilmsNetworkService(networkService: networkService)
        let imageLoaderUseCase = ImageLoaderUseCase(networkService: networkService, cacheService: imageCacheService)
        let favoritesUseCase = FavoritesFilmUseCase(userDeafaults: userDefaults)
        let viewModel = FavoritesViewModel(favoritesUseCase: favoritesUseCase, imageLoaderUseCase: imageLoaderUseCase)
        let router = FavoritesRouter()
        let viewController = FavoritesViewController(viewModel: viewModel, router: router)
        router.viewController = viewController
        return viewController
    }
}
