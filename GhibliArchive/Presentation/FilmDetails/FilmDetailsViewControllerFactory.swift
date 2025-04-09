//
//  FilmDetailsViewControllerFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

struct FilmDetailsViewControllerFactory {
    static func make(with id: String) -> FilmDetailsViewController {
        let service = NetworkService()
        let cacheService = ImageCacheService()
        let filmsService = FilmsNetworkService(networkService: service)
        let filmDetailsUseCase = FilmDetailsUseCase(filmsNetworkService: filmsService)
        let imageUseCase = ImageLoaderUseCase(networkService: service, cacheService: cacheService)
        let userDefaults = FilmUserDefaults()
        let favoritesUseCase = FavoritesFilmUseCase(userDefaults: userDefaults)
        let viewModel = FilmDetailsViewModel(
            id: id,
            filmDetailsUseCase: filmDetailsUseCase, 
            imageLoaderUseCase: imageUseCase,
            favoritesUseCase: favoritesUseCase
        )
        
        return .init(viewModel: viewModel)
    }
}
