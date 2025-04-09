//
//  FilmDetailsViewControllerBuilder.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

final class FilmDetailsViewControllerBuilder {
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
    
    func build(with id: String) -> FilmDetailsViewController {
        let filmsNetworkService = FilmsNetworkService(networkService: networkService)
        let filmDetailsUseCase = FilmDetailsUseCase(filmsNetworkService: filmsNetworkService)
        let imageLoaderUseCase = ImageLoaderUseCase(networkService: networkService, cacheService: imageCacheService)
        let favoritesUseCase = FavoritesFilmUseCase(userDeafaults: userDefaults)
        let viewModel = FilmDetailsViewModel(id: id, filmDetailsUseCase: filmDetailsUseCase, imageLoaderUseCase: imageLoaderUseCase, favoritesUseCase: favoritesUseCase)
        
        return .init(viewModel: viewModel)
    }
}
