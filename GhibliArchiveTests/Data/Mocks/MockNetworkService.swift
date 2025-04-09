//
//  MockNetworkService.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import XCTest
import Combine

@testable import GhibliArchive

final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Any, NetworkError>?
    var imageToReturn: UIImage?
    
    func fetch<T>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let result = result else {
            return Fail(error: .notFound)
                .eraseToAnyPublisher()
        }
        switch result {
        case .success(let value):
            if let typedValue = value as? T {
                return Just(typedValue)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: .invalidJSON(.init()))
                    .eraseToAnyPublisher()
            }
            
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return Just(imageToReturn)
            .eraseToAnyPublisher()
    }
}

