//
//  FilmsNetworkService.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import Foundation

protocol FilmsNetworkServiceProtocol {
    func fetchFilms() -> AnyPublisher<[Film], NetworkError>
}

final class FilmsNetworkService: FilmsNetworkServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchFilms() -> AnyPublisher<[Film], NetworkError> {
        let endpoint = FilmEndpoint.getFilms
        return networkService.fetch(endpoint: endpoint)
            .map { (response: [Film]) in
                response
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
