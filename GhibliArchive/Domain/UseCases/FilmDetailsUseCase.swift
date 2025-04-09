//
//  FilmDetailsUseCase.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine

protocol FilmDetailsUseCaseProtocol {
    func execute(with id: String) -> AnyPublisher<Film, NetworkError>
}

final class FilmDetailsUseCase: FilmDetailsUseCaseProtocol {
    private let filmsNetworkService: FilmsNetworkServiceProtocol
    
    init(filmsNetworkService: FilmsNetworkServiceProtocol) {
        self.filmsNetworkService = filmsNetworkService
    }
    
    func execute(with id: String) -> AnyPublisher<Film, NetworkError> {
        return filmsNetworkService.fetchFilm(by: id)
    }
}
