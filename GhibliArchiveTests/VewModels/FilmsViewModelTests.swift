//
//  FilmsViewModelTests.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import XCTest
import Combine
import UIKit

@testable import GhibliArchive

final class FilmsViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    func makeSut(
        filmsUseCase: FilmsUseCaseProtocol = MockFilmsUseCase(),
        imageLoaderUseCase: ImageLoaderUseCaseProtocol = SpyImageLoaderUseCase()
    ) -> FilmsViewModel {
        return .init(filmsUseCase: filmsUseCase, imageLoaderUseCase: imageLoaderUseCase)

    }
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func test_start_fetchesFilmsAndUpdatesStateToSuccess() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .success([.fixture(title: "Totoro")])
        let spy = SpyImageLoaderUseCase()
        let sut = makeSut(filmsUseCase: mockFilmsUseCase, imageLoaderUseCase: spy)
        let expectation = XCTestExpectation(description: "State updates to success")
        
        sut.statePublisher
            .dropFirst() // ignore initial loading
            .sink { state in
                if case .success = state {
                    XCTAssertTrue(spy.executeCalled)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.start()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_start_whenUseCaseFails_shouldUpdateStateToError() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .failure(.invalidResponse)
        
        let sut = makeSut(filmsUseCase: mockFilmsUseCase)
        
        let expectation = XCTestExpectation(description: "State updates to error")
        
        sut.statePublisher
            .dropFirst() // ignore initial loading
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.start()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_searchTextPublisher_withMatchingFilm_shouldEmitSearchedState() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .success([.fixture(title: "Totoro")])
        
        let sut = makeSut(filmsUseCase: mockFilmsUseCase)
        let expectation = XCTestExpectation(description: "Search emits .searched state")
        
        sut.statePublisher
            .dropFirst(2) // Ignora loading + success
            .sink { state in
                if case .searched(let snapshot) = state {
                    XCTAssertEqual(snapshot.itemIdentifiers.count, 1)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()
        sut.searchTextPublisher.send("Totoro")

        wait(for: [expectation], timeout: 1)
    }

    func test_searchTextPublisher_withNoMatchingFilm_shouldEmitEmptySearchedState() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .success([.fixture(title: "Totoro")])
        
        let sut = makeSut(filmsUseCase: mockFilmsUseCase)
        let expectation = XCTestExpectation(description: "Search emits .emptySearched state")

        sut.statePublisher
            .dropFirst(2) // loading + success
            .sink { state in
                if case .emptySearched = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()
        sut.searchTextPublisher.send("Ponyo")

        wait(for: [expectation], timeout: 1)
    }

    
    func test_tryAgain_callsFetchFilms() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .success([.fixture(title: "Totoro")])
        
        let sut = makeSut(filmsUseCase: mockFilmsUseCase)
        let expectation = XCTestExpectation(description: "Try again triggers fetchFilms and updates to success")
        
        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .success = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.tryAgain()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_didSelectFilm_shouldEmitFilmId() {
        let expectedId = "123"
        let expectation = XCTestExpectation(description: "Film ID emitted for navigation")
        
        let sut = makeSut()
        sut.onNavigateToFilmDetailsPublisher
            .sink { id in
                XCTAssertEqual(id, expectedId)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didSelectFilm(with: expectedId)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_didTapFavorites_shouldEmitNavigationEvent() {
        let expectation = XCTestExpectation(description: "Navigation to favorites emitted")
        let sut = makeSut()

        sut.onNavigateToFavoritesPublisher
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.didTapFavorites()
        wait(for: [expectation], timeout: 1)
    }
    
    func test_searchBarDidBeginEditing_shouldEmitWillSearchState() {
        let mockFilmsUseCase = MockFilmsUseCase()
        mockFilmsUseCase.result = .success([.fixture(title: "Totoro")])
        
        let sut = makeSut(filmsUseCase: mockFilmsUseCase)
        let expectation = XCTestExpectation(description: "WillSearch state triggered")
        
        sut.statePublisher
            .dropFirst(2) // loading + success
            .sink { state in
                if case .willSearch = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.start()
        sut.searchBarDidBeginEditing()
        wait(for: [expectation], timeout: 1)
    }
}
