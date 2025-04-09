//
//  MockFilmsUseCase.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Combine
@testable import GhibliArchive

// MARK: - Mocks & Spies

final class MockFilmsUseCase: FilmsUseCaseProtocol {
    var result: Result<[Film], NetworkError> = .success([])
    
    func execute() -> AnyPublisher<[Film], NetworkError> {
        return result.publisher.eraseToAnyPublisher()
    }
}
