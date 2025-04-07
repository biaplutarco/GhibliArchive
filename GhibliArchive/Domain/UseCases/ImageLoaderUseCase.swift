//
//  ImageLoaderUseCase.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 05/04/25.
//

import Combine
import UIKit

protocol ImageLoaderUseCaseProtocol {
    func execute(from urlString: String) -> AnyPublisher<UIImage?, Never>
}

class ImageLoaderUseCase: ImageLoaderUseCaseProtocol {
    private let networkService: NetworkService
    private let cacheService: ImageCacheServiceProtocol

    init(networkService: NetworkService, cacheService: ImageCacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func execute(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        return networkService.fetchImage(from: url)
    }
}
