//
//  FilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import UIKit

typealias Snapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, FilmsCollectionViewItem>

// MARK: - Protocol

protocol FilmViewModelProtocol {
    var mostRatedDataSourcePublisher: AnyPublisher<Snapshot, Never> { get }
    var posterFilmDataSourcePublisher: AnyPublisher<Snapshot, Never> { get }
    var searchedFilmDataSourcePublisher: AnyPublisher<Snapshot, Never> { get }
    var searchTextPublisher: CurrentValueSubject<String, Never> { get }

    func start()
    func searchBarDidBeginEditing()
}

// MARK: - Class

final class FilmsViewModel {
    private let filmsUseCase: FilmsUseCaseProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    
    private var mostRatedFilmViewModels = CurrentValueSubject<[MostRatedFilmViewModel], Never>([])
    private var posterFilmsViewModels = CurrentValueSubject<[MostRatedFilmViewModel], Never>([])
    private var searchedFilmsViewModels = CurrentValueSubject<[MostRatedFilmViewModel], Never>([])

    private var filmImage = CurrentValueSubject<UIImage?, Never>(nil)
    private var cancellables: Set<AnyCancellable> = []
    private var allFilms: [Film] = []
    
    var mostRatedDataSourcePublisher: AnyPublisher<Snapshot, Never> {
        mostRatedFilmViewModels
                .map { self.createFilmsDataSource(with: $0) }
                .eraseToAnyPublisher()
    }
    var posterFilmDataSourcePublisher: AnyPublisher<Snapshot, Never> {
        posterFilmsViewModels
            .map { self.createFilmsDataSource(with: $0) }
            .eraseToAnyPublisher()
    }
    var searchedFilmDataSourcePublisher: AnyPublisher<Snapshot, Never> {
        searchedFilmsViewModels
            .map { self.createFilmsDataSource(with: $0) }
            .eraseToAnyPublisher()
    }
    var searchTextPublisher = CurrentValueSubject<String, Never>(.init())
    
    // MARK: - Init

    init(filmsUseCase: FilmsUseCaseProtocol, imageLoaderUseCase: ImageLoaderUseCaseProtocol) {
        self.filmsUseCase = filmsUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
        
        subscriberToSearchFilm()
    }
    
    // MARK: - Private Methods
    
    private func createFilmsDataSource(with viewModels: [MostRatedFilmViewModel]) -> Snapshot {
        var snapshot = Snapshot()

        if !viewModels.isEmpty {
            let section: FilmsCollectionViewSection = .main
            snapshot.appendSections([section])
            viewModels.forEach { snapshot.appendItems([.film($0)], toSection: section) }
        }

        return snapshot
    }
    
    private func filterMostRatedFilms(_ films: [Film]) -> [Film] {
        films.filter { Int($0.rtScore) ?? .zero > 95 }
    }
    
    func searchBarDidBeginEditing() {
        searchedFilmsViewModels.value = posterFilmsViewModels.value
    }
    
    func subscriberToSearchFilm() {
        searchTextPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { text in
                self.allFilms.filter { $0.title.contains(text) }
            }
            .sink { [weak self] filteredFilms in
                guard let self = self else { return }
                
                if filteredFilms.isEmpty {
                    self.searchedFilmsViewModels.value = posterFilmsViewModels.value
                } else {
                    self.searchedFilmsViewModels.value = filteredFilms.map {
                        MostRatedFilmViewModelFactory.create(
                            from: $0,
                            imageLoader: { imageString in
                                self.imageLoaderUseCase.execute(from: imageString)
                            }
                        )
                    }
                }
                
            }
            .store(in: &cancellables)
    }
}

// MARK: - FilmViewModelProtocol

extension FilmsViewModel: FilmViewModelProtocol {
    func start() {
        filmsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    return
                }
            }, receiveValue: { films in
                self.allFilms = films
                self.posterFilmsViewModels.value = films.map {
                    MostRatedFilmViewModelFactory.create(
                        from: $0,
                        imageLoader: { imageString in
                            self.imageLoaderUseCase.execute(from: imageString)
                        }
                    )
                }
                self.mostRatedFilmViewModels.value = self.filterMostRatedFilms(films).map {
                    MostRatedFilmViewModelFactory.create(
                        from: $0,
                        imageLoader: { imageString in
                            self.imageLoaderUseCase.execute(from: imageString)
                        }
                    )
                }
            })
            .store(in: &cancellables)
    }
}
