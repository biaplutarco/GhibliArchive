//
//  FilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import UIKit

typealias MostRatedFilmsSnapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, MostRatedFilmViewModel>
typealias PosterFilmsSnapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, PosterFilmViewModel>

// MARK: - Protocol

protocol FilmViewModelProtocol {
    var searchTextPublisher: CurrentValueSubject<String, Never> { get }
    var statePublisher: AnyPublisher<FilmsViewControllerState, Never> { get }
    var onNavigateToFilmDetailsPublisher: PassthroughSubject<String, Never> { get }
    var onNavigateToFavoritesPublisher: PassthroughSubject<Void, Never> { get }
    
    func start()
    func tryAgain()
    func searchBarDidBeginEditing()
    func didSelectFilm(with id: String)
    func didTapFavorites()
}

// MARK: - Class

final class FilmsViewModel {
    // MARK: - Properties
    
    private let filmsUseCase: FilmsUseCaseProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    private var allFilms: [Film] = []
    
    private var warningViewModel: WarningViewModel {
        .init(
            title: "🌿 Kodama Oops! 🌿",
            message: "The Kodama are whispering... Something has gone awry in the forest. 🌳✨ \nPlease try again, and the path may clear once more.",
            buttonTitle: "Try Again"
        )
    }

    // MARK: - Observables

    private var state = CurrentValueSubject<FilmsViewControllerState, Never>(.loading)
    private var filmImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables: Set<AnyCancellable> = []
    
    var searchTextPublisher = CurrentValueSubject<String, Never>(.init())
    var statePublisher: AnyPublisher<FilmsViewControllerState, Never> { state.eraseToAnyPublisher() }
    var onNavigateToFilmDetailsPublisher = PassthroughSubject<String, Never>()
    var onNavigateToFavoritesPublisher = PassthroughSubject<Void, Never>()

    // MARK: - Init

    init(filmsUseCase: FilmsUseCaseProtocol, imageLoaderUseCase: ImageLoaderUseCaseProtocol) {
        self.filmsUseCase = filmsUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
        
        subscriberToSearchFilm()
    }
    
    // MARK: - Private Methods
    
    private func fetchFilms() {
        filmsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.state.send(.error(self.warningViewModel))
                }
            }, receiveValue: { films in
                self.allFilms = films
                let mostRatedFilms = self.filterMostRatedFilms(films)
                let mostRatedViewMdoels = self.getMosterRatedViewModels(mostRatedFilms)
                let posterFilmViewModels = self.getPosterFilmViewModels(films)

                self.state.send(.success(
                    mostRatedSnapshot: self.createMostRatedFilmsSnapshot(with: mostRatedViewMdoels),
                    posterFilmSnapshot: self.createPosterFilmsSnapshot(with: posterFilmViewModels)
                ))
            })
            .store(in: &cancellables)
    }
    
    // MARK: - DataSource
    
    private func createMostRatedFilmsSnapshot(with viewModels: [MostRatedFilmViewModel]) -> MostRatedFilmsSnapshot {
        var snapshot = MostRatedFilmsSnapshot()
        if !viewModels.isEmpty {
            let section: FilmsCollectionViewSection = .unique
            snapshot.appendSections([section])
            viewModels.forEach { snapshot.appendItems([$0], toSection: section) }
        }
        return snapshot
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
    
    // MARK: - Logics
    
    private func filterMostRatedFilms(_ films: [Film]) -> [Film] {
        films.filter { Int($0.rtScore) ?? .zero > 95 }
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
    
    private func getMosterRatedViewModels(_ films: [Film]) -> [MostRatedFilmViewModel] {
        films.map {
            MostRatedFilmViewModelFactory.create(
                from: $0,
                imageLoader: { imageString in
                    self.imageLoaderUseCase.execute(from: imageString)
                }
            )
        }
    }
    
    // MARK: - Setup Bindings
    
    private func subscriberToSearchFilm() {
        searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { text in
                self.allFilms.filter { $0.title.contains(text) }
            }
            .sink { [weak self] seachedFilms in
                guard let self = self else { return }
                if seachedFilms.isEmpty {
                    self.state.send(.emptySearched)
                } else {
                    let viewModels = self.getPosterFilmViewModels(seachedFilms)
                    self.state.send(.searched(self.createPosterFilmsSnapshot(with: viewModels)))
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - FilmViewModelProtocol

extension FilmsViewModel: FilmViewModelProtocol {
    func didTapFavorites() {
        onNavigateToFavoritesPublisher.send()
    }
    
    func didSelectFilm(with id: String) {
        onNavigateToFilmDetailsPublisher.send(id)
    }
    
    func start() {
        fetchFilms()
    }
    
    func tryAgain() {
        fetchFilms()
    }
    
    func searchBarDidBeginEditing() {
        let viewModels = getPosterFilmViewModels(allFilms)
        let snapshot = createPosterFilmsSnapshot(with: viewModels)
        
        state.send(.willSearch(snapshot))
    }
}
