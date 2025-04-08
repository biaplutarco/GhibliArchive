//
//  FilmsViewControllerBuilder.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Foundation

final class FilmsViewControllerBuilder {
    private let networkService: NetworkServiceProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        imageCacheService: ImageCacheServiceProtocol = ImageCacheService()
    ) {
        self.networkService = networkService
        self.imageCacheService = imageCacheService
    }
    
    func build() -> FilmsViewController {
        let filmsNetworkService = FilmsNetworkService(networkService: networkService)
        let filmsUseCase = FilmsUseCase(filmsNetworkService: filmsNetworkService)
        let imageLoaderUseCase = ImageLoaderUseCase(networkService: networkService, cacheService: imageCacheService)
        let viewModel = FilmsViewModel(filmsUseCase: filmsUseCase, imageLoaderUseCase: imageLoaderUseCase)
        
        return .init(viewModel: viewModel)
    }
}
