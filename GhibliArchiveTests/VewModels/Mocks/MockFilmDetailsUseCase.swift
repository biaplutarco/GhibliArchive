//
//  MockFilmDetailsUseCase.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Combine
@testable import GhibliArchive

final class MockFilmDetailsUseCase: FilmDetailsUseCaseProtocol {
    var result: Result<Film, NetworkError> = .failure(.notFound)

    func execute(with id: String) -> AnyPublisher<Film, NetworkError> {
        return result.publisher.eraseToAnyPublisher()
    }
}
