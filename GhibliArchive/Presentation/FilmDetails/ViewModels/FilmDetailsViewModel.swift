//
//  FilmDetailsViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit
import Combine

// MARK: - Protocol

protocol FilmDetailsViewModelProtocol {
    var statePublisher: AnyPublisher<FilmDetailsViewControllerState, Never> { get }
    
    func start()
    func tryAgain()
    func didTapFavorite()
}

// MARK: - Class

final class FilmDetailsViewModel {
    
    // MARK: - Properties
    
    private let favoritesUseCase: FavoritesFilmUseCasaProtocol
    private let filmDetailsUseCase: FilmDetailsUseCaseProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    private let id: String
    private var film: Film?
    
    private var favoriteMessage: String {
        "Added to your favorites ✨"
    }
    private var unfavoriteMessage: String {
        "💨 Removed from Favorites"
    }
    private var warningViewModel: WarningViewModel {
        .init(
            title: "🌿 Kodama Oops! 🌿",
            message: "The Kodama are whispering... Something has gone awry in the forest. 🌳✨ \nPlease try again, and the path may clear once more.",
            buttonTitle: "Try Again"
        )
    }
    
    // MARK: - Observables
    
    private var state = CurrentValueSubject<FilmDetailsViewControllerState, Never>(.loading)
    private var filmImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables: Set<AnyCancellable> = []
    
    var statePublisher: AnyPublisher<FilmDetailsViewControllerState, Never> { state.eraseToAnyPublisher() }
    
    // MARK: - Initialization
    init(id: String, 
         filmDetailsUseCase: FilmDetailsUseCaseProtocol,
         imageLoaderUseCase: ImageLoaderUseCaseProtocol,
         favoritesUseCase: FavoritesFilmUseCasaProtocol
    ) {
        self.id = id
        self.filmDetailsUseCase = filmDetailsUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
        self.favoritesUseCase = favoritesUseCase
    }
    // MARK: - Private Methods
    
    private func getContentViewModel(from film: Film) -> FilmDetailsContentViewModel {
        FilmDetailsContentViewModelFactory.create(
            from: film,
            isFavorite: favoritesUseCase.isFavorite(film.id)
        ) { imageString in
            self.imageLoaderUseCase.execute(from: imageString)
        }
    }
    
    private func fetchFilmDetails() {
        filmDetailsUseCase.execute(with: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.state.send(.error(self.warningViewModel))
                }
            }, receiveValue: { film in
                self.film = film
                let viewModel = self.getContentViewModel(from: film)
                self.state.send(.success(viewModel))
            })
            .store(in: &cancellables)
    }
}

// MARK: - FilmDetailsViewModelProtocol

extension FilmDetailsViewModel: FilmDetailsViewModelProtocol {
    func start() {
        fetchFilmDetails()
    }
    
    func tryAgain() {
        fetchFilmDetails()
    }
    
    func didTapFavorite() {
        guard let film = self.film else {
            return
        }
        let message = favoritesUseCase.isFavorite(film.id) ? unfavoriteMessage : favoriteMessage
        state.send(.alert(message))
        favoritesUseCase.toggleFavorite(film)
    }
}
