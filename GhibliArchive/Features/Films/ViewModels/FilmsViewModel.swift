//
//  FilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import UIKit

typealias MostRatedFilmsSnapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, MostRatedFilmsCollectionViewItem>
typealias PosterFilmsSnapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, PosterFilmsCollectionViewItem>

// MARK: - Protocol

protocol FilmViewModelProtocol {
    var searchTextPublisher: CurrentValueSubject<String, Never> { get }
    var statePublisher: AnyPublisher<FilmsViewControllerState, Never> { get }
    
    func start()
    func tryAgain()
    func searchBarDidBeginEditing()
}

// MARK: - Class

final class FilmsViewModel {
    private let filmsUseCase: FilmsUseCaseProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    
    private var state = CurrentValueSubject<FilmsViewControllerState, Never>(.loading)
    private var filmImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables: Set<AnyCancellable> = []
    private var allFilms: [Film] = []
    
    var searchTextPublisher = CurrentValueSubject<String, Never>(.init())
    var statePublisher: AnyPublisher<FilmsViewControllerState, Never> { state.eraseToAnyPublisher() }

    // MARK: - Init

    init(filmsUseCase: FilmsUseCaseProtocol, imageLoaderUseCase: ImageLoaderUseCaseProtocol) {
        self.filmsUseCase = filmsUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
        
        subscriberToSearchFilm()
    }
    
    private func fetchFilms() {
        filmsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.state.value = .error(
                        message: "The Kodama are whispering... Something has gone awry in the forest. 🌳✨ \nPlease try again, and the path may clear once more.",
                        title: "🌿 Kodama Oops! 🌿"
                    )
                }
            }, receiveValue: { films in
                self.allFilms = films
                let mostRatedFilms = self.filterMostRatedFilms(films)
                let mostRatedViewMdoels = self.getMosterRatedViewModels(mostRatedFilms)
                let posterFilmViewModels = self.getPosterFilmViewModels(films)

                self.state.value = .success(
                    mostRatedSnapshot: self.createMostRatedFilmsDataSource(with: mostRatedViewMdoels),
                    posterFilmSnapshot: self.createPosterFilmsDataSource(with: posterFilmViewModels)
                )
            })
            .store(in: &cancellables)
    }
    
    // MARK: - DataSource
    
    private func createMostRatedFilmsDataSource(with viewModels: [MostRatedFilmViewModel]) -> MostRatedFilmsSnapshot {
        var snapshot = MostRatedFilmsSnapshot()

        if !viewModels.isEmpty {
            let section: FilmsCollectionViewSection = .unique
            snapshot.appendSections([section])
            viewModels.forEach { snapshot.appendItems([.mostRatedFilm($0)], toSection: section) }
        }

        return snapshot
    }
    
    private func createPosterFilmsDataSource(with viewModels: [PosterFilmViewModel]) -> PosterFilmsSnapshot {
        var snapshot = PosterFilmsSnapshot()

        if !viewModels.isEmpty {
            let section: FilmsCollectionViewSection = .unique
            snapshot.appendSections([section])
            viewModels.forEach { snapshot.appendItems([.posterFilm($0)], toSection: section) }
        }

        return snapshot
    }
    
    // MARK: - SetupStates
    
    private func showAllFilmsBeforeSearching() {
        let viewModels = getPosterFilmViewModels(allFilms)
        let dataSource = createPosterFilmsDataSource(with: viewModels)
        state.value = .searched(dataSource)
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
                    showAllFilmsBeforeSearching()
                } else {
                    let viewModels = self.getPosterFilmViewModels(seachedFilms)
                    self.state.value = .searched(self.createPosterFilmsDataSource(with: viewModels))
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - FilmViewModelProtocol

extension FilmsViewModel: FilmViewModelProtocol {
    func start() {
        self.state.value = .error(
            message: "The Kodama are whispering... Something has gone awry in the forest. 🌳✨ \nPlease try again, and the path may clear once more.",
            title: "🌿 Kodama Oops! 🌿"
        )
    }
    
    func tryAgain() {
        filmsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.state.value = .error(
                        message: "The Kodama are whispering... Something has gone awry in the forest. 🌳✨ \nPlease try again, and the path may clear once more.",
                        title: "🌿 Kodama Oops! 🌿"
                    )
                }
            }, receiveValue: { films in
                self.allFilms = films
                let mostRatedFilms = self.filterMostRatedFilms(films)
                let mostRatedViewMdoels = self.getMosterRatedViewModels(mostRatedFilms)
                let posterFilmViewModels = self.getPosterFilmViewModels(films)

                self.state.value = .success(
                    mostRatedSnapshot: self.createMostRatedFilmsDataSource(with: mostRatedViewMdoels),
                    posterFilmSnapshot: self.createPosterFilmsDataSource(with: posterFilmViewModels)
                )
            })
            .store(in: &cancellables)
    }
    
    func searchBarDidBeginEditing() {
        showAllFilmsBeforeSearching()
    }
}
