//
//  FilmRepository.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import Foundation

protocol FilmRepository {
    func create(_ film: Film) async throws
    func deleteFilm(for id: String) async throws
    func find(id: String) async throws -> Film?
    func fetchFilms() throws -> [Film]
}

protocol FilmsRepository {
    func fetchFilms() -> AnyPublisher<[Film], NetworkError>
}

final class FilmsRepositoryImpl: FilmsRepository {
    private let networkService: FilmsNetworkServiceProtocol
    
    init(networkService: FilmsNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchFilms() -> AnyPublisher<[Film], NetworkError> {
        return networkService.fetchFilms()
    }
}
