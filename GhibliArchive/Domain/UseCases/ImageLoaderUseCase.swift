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
    private let networkService: NetworkServiceProtocol
    private let cacheService: ImageCacheServiceProtocol

    init(networkService: NetworkServiceProtocol, cacheService: ImageCacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func execute(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }
        if let cachedImage = cacheService.getImage(for: url) {
            return Just(cachedImage)
                .eraseToAnyPublisher()
        }
        
        return networkService
            .fetchImage(from: url)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image = image else { return }
                self?.cacheService.saveImage(image, for: url)
            })
            .eraseToAnyPublisher()
    }
}
