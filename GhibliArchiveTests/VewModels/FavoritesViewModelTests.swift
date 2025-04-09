//
//  FavoritesViewModelTests.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import XCTest
import Combine

@testable import GhibliArchive

final class FavoritesViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    func makeSut(
        favoritesUseCase: FavoritesFilmUseCasaProtocol = MockFavoritesUseCase(),
        imageLoaderUseCase: ImageLoaderUseCaseProtocol = SpyImageLoaderUseCase()
    ) -> FavoritesViewModel {
        return .init(favoritesUseCase: favoritesUseCase, imageLoaderUseCase: imageLoaderUseCase)
    }

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func test_start_withFavorites_shouldEmitFilmsState() {
        let mockFavoritesUseCase = MockFavoritesUseCase()
        mockFavoritesUseCase.favoriteFilms = [.fixture()]
        let sut = makeSut(favoritesUseCase: mockFavoritesUseCase)
        
        let expectation = expectation(description: "Should emit .films state")

        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .films(let snapshot) = state {
                    XCTAssertEqual(snapshot.numberOfItems, 1)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func test_start_withoutFavorites_shouldEmitEmptyState() {
        let mockFavoritesUseCase = MockFavoritesUseCase()
        mockFavoritesUseCase.favoriteFilms = []
        let sut = makeSut(favoritesUseCase: mockFavoritesUseCase)
        
        let expectation = expectation(description: "Should emit .empty state")

        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .empty(let warning) = state {
                    XCTAssertEqual(warning.title, "Your Favorites Sleeps Like Haku in the River...")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_didTapExplore_shouldSendNavigationToRoot() {
        let sut = makeSut()
        let expectation = expectation(description: "Should send navigation to root")

        sut.onNavigateToRootViewController
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.didTapExplore()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_didSelectFilm_shouldSendFilmID() {
        let sut = makeSut()

        let expectedID = "123"
        let expectation = expectation(description: "Should send selected film ID")

        sut.onNavigateToFilmDetailsPublisher
            .sink { filmID in
                XCTAssertEqual(filmID, expectedID)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.didSelectFilm(with: expectedID)

        wait(for: [expectation], timeout: 1.0)
    }
}
