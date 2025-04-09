//
//  FilmDetailsViewModelTests.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import XCTest
import Combine

@testable import GhibliArchive

final class FilmDetailsViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    func makeSut(
        id: String = .init(),
        filmsUseCase: FilmDetailsUseCaseProtocol = MockFilmDetailsUseCase(),
        imageLoaderUseCase: ImageLoaderUseCaseProtocol = SpyImageLoaderUseCase(),
        favoritesUseCase: FavoritesFilmUseCasaProtocol = SpyFavoritesUseCase()
    ) -> FilmDetailsViewModel {
        return .init(
            id: id,
            filmDetailsUseCase: filmsUseCase,
            imageLoaderUseCase: imageLoaderUseCase, 
            favoritesUseCase: favoritesUseCase
        )

    }

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func test_start_withSuccess_shouldEmitSuccessState() {
        let mockFilmDetailsUseCase = MockFilmDetailsUseCase()
        mockFilmDetailsUseCase.result = .success(.fixture(title: "Totoro"))
        let sut = makeSut(filmsUseCase: mockFilmDetailsUseCase)
        
        let expectation = XCTestExpectation(description: "Should emit success state")

        sut.statePublisher
            .dropFirst() // skip initial loading state
            .sink { state in
                if case .success(let viewModel) = state {
                    XCTAssertEqual(viewModel.title, "Totoro")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()
        wait(for: [expectation], timeout: 1.0)
    }

    func test_start_withFailure_shouldEmitErrorState() {
        let mockFilmDetailsUseCase = MockFilmDetailsUseCase()
        mockFilmDetailsUseCase.result = .failure(NetworkError.invalidResponse)
        let sut = makeSut(filmsUseCase: mockFilmDetailsUseCase)
        
        let expectation = XCTestExpectation(description: "Should emit error state")

        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .error(let warning) = state {
                    XCTAssertEqual(warning.title, "🌿 Kodama Oops! 🌿")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.start()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_tryAgain_shouldCallFetchFilmDetailsAgain() {
        let mockFilmDetailsUseCase = MockFilmDetailsUseCase()
        mockFilmDetailsUseCase.result = .success(.fixture(title: "Totoro"))
        let sut = makeSut(filmsUseCase: mockFilmDetailsUseCase)
        
        let expectation = XCTestExpectation(description: "Should emit success state again")

        sut.statePublisher
            .dropFirst()
            .sink { state in
                if case .success = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.tryAgain()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func test_didTapFavorite_shouldCallToggleFavorite() {
        let mockFilmDetailsUseCase = MockFilmDetailsUseCase()
        mockFilmDetailsUseCase.result = .success(.fixture(id: "123" ,title: "Totoro"))
        let spyFavoritesUseCase = SpyFavoritesUseCase()
        let sut = makeSut(id: "123", filmsUseCase: mockFilmDetailsUseCase, favoritesUseCase: spyFavoritesUseCase)
        
        let expectation = XCTestExpectation(description: "Favorite toggled")

        sut.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sut.didTapFavorite()
            XCTAssertTrue(spyFavoritesUseCase.toggleFavoriteeCalled)
            XCTAssertEqual(spyFavoritesUseCase.toggleFavoriteCalledWith?.id, "123")
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
