//
//  FilmsUserCase.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import Foundation

protocol FilmsUseCaseProtocol {
    func execute() -> AnyPublisher<[Film], NetworkError>
}

final class FilmsUseCase: FilmsUseCaseProtocol {
    private let filmsNetworkService: FilmsNetworkServiceProtocol
    
    init(filmsNetworkService: FilmsNetworkServiceProtocol) {
        self.filmsNetworkService = filmsNetworkService
    }
    
    func execute() -> AnyPublisher<[Film], NetworkError> {
        return filmsNetworkService.fetchFilms()
    }
}
