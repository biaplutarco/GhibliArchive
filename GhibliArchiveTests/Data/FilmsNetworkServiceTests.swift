//
//  FilmsNetworkServiceTests.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import XCTest
import Combine

@testable import GhibliArchive

final class FilmsNetworkServiceTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func makeSut(networkService: NetworkServiceProtocol) -> FilmsNetworkService {
        return FilmsNetworkService(networkService: networkService)
    }

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - fetchFilms
    
    func test_FetchFilms_Success() {
        let films: [Film] = [.fixture(id: "1", title: "Mononoke")]
        let mockService: MockNetworkService = .init()
        mockService.result = .success(films)
        
        let sut = makeSut(networkService: mockService)
        let expectation = XCTestExpectation(description: "fetchFilms")

        sut.fetchFilms()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, films)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func test_FetchFilms_Failure() {
        let networkError: NetworkError = .invalidResponse
        let mockService: MockNetworkService = .init()
        mockService.result = .failure(.invalidResponse)
        
        let sut = makeSut(networkService: mockService)
        let expectation = XCTestExpectation(description: "fetchFilms")

        sut.fetchFilms()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, networkError)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    // MARK: - fetchFilmsBy

    func test_FetchFilmById_Success() {
        let film: Film = .fixture(id: "1", title: "Mononoke")
        let mockService: MockNetworkService = .init()
        mockService.result = .success(film)
        
        let sut = makeSut(networkService: mockService)
        let expectation = XCTestExpectation(description: "fetchFilmby")

        sut.fetchFilm(by: "1")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            }, receiveValue: { result in
                // Então
                XCTAssertEqual(result, film)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
