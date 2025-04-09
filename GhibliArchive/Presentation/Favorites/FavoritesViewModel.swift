//
//  FavoritesViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import UIKit
import Combine

// MARK: - Protocol

protocol FavoritesViewModelProtocol {
    var onNavigateToFilmDetailsPublisher: PassthroughSubject<String, Never> { get }
    var onNavigateToRootViewController: PassthroughSubject<Void, Never> { get }
    var statePublisher: AnyPublisher<FavoritesViewControllerState, Never> { get }

    func didSelectFilm(with id: String)
    func didTapExplore()
    func start()
}

// MARK: - Class

final class FavoritesViewModel {
    private let favoritesUseCase: FavoritesFilmUseCasaProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    
    private var warningViewModel: WarningViewModel {
        .init(
            title: "Your Favorites Sleeps Like Haku in the River...",
            message: "It seems your heart hasn't found a magical film yet... how about exploring the wonders of Ghibli and adding your favorites to the list?",
            buttonTitle: "Explore!"
        )
    }

    // MARK: - Observables

    private var state = CurrentValueSubject<FavoritesViewControllerState, Never>(.loading)
    private var filmImage = CurrentValueSubject<UIImage?, Never>(nil)

    var statePublisher: AnyPublisher<FavoritesViewControllerState, Never> { state.eraseToAnyPublisher() }
    var onNavigateToFilmDetailsPublisher = PassthroughSubject<String, Never>()
    var onNavigateToRootViewController = PassthroughSubject<Void, Never>()

    // MARK: - Inits

    init(favoritesUseCase: FavoritesFilmUseCasaProtocol, imageLoaderUseCase: ImageLoaderUseCaseProtocol) {
        self.favoritesUseCase = favoritesUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
    }
    
    private func createPosterFilmsSnapshot(with viewModels: [PosterFilmViewModel]) -> PosterFilmsSnapshot {
        var snapshot = PosterFilmsSnapshot()
        if !viewModels.isEmpty {
            let section: FilmsCollectionViewSection = .unique
            snapshot.appendSections([section])
            viewModels.forEach { snapshot.appendItems([$0], toSection: section) }
        }
        return snapshot
    }
    
    private func getPosterFilmViewModels(_ films: [Film]) -> [PosterFilmViewModel] {
        films.map {
            PosterFilmViewModelFactory.create(
                from: $0,
                imageLoader: { imageString in
                    self.imageLoaderUseCase.execute(from: imageString)
                }
            )
        }
    }
}

// MARK: - FavoritesViewModelProtocol

extension FavoritesViewModel: FavoritesViewModelProtocol {
    func didTapExplore() {
        onNavigateToRootViewController.send()
    }
    
    func didSelectFilm(with id: String) {
        onNavigateToFilmDetailsPublisher.send(id)
    }
    
    func start() {
        let favorites = favoritesUseCase.getFavorites()
        guard !favorites.isEmpty else {
            return state.send(.empty(warningViewModel))
        }
        let viewModels = getPosterFilmViewModels(favorites)
        let snapshot = createPosterFilmsSnapshot(with: viewModels)
        
        state.send(.films(snapshot))
    }
}
