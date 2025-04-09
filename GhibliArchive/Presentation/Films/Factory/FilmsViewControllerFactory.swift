//
//  FilmsViewControllerFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Foundation

struct FilmsViewControllerFactory {
    static func make() -> FilmsViewController {
        let service = NetworkService()
        let cacheService = ImageCacheService()
        let filmsService = FilmsNetworkService(networkService: service)
        let filmsUseCase = FilmsUseCase(filmsNetworkService: filmsService)
        let imageUseCase = ImageLoaderUseCase(networkService: service, cacheService: cacheService)
        let viewModel = FilmsViewModel(filmsUseCase: filmsUseCase, imageLoaderUseCase: imageUseCase)
        let router = FilmsRouter()
        let viewController = FilmsViewController(viewModel: viewModel, router: router)
        router.viewController = viewController
        return viewController
    }
}
