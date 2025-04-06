//
//  FilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Combine
import UIKit

enum FilmsViewControllerState {
    case idle
    case empty
    case loading
    case error(String)
    case success([Film])
}

// MARK: - Section

enum FilmsCollectionViewSection: Hashable {
    case mostRated(MostRatedFilmsSectionModel)
}

// MARK: - Section Item

enum FilmsCollectionViewItem: Hashable {
    case mostRated(MostRatedFilmViewModel)
}

// MARK: - Section Model

struct MostRatedFilmsSectionModel: Hashable {
    let title: String
//    let films: [MostRatedFilmViewModel]
}


// MARK: - Protocol

protocol FilmViewModelProtocol {
    var dataSourcePublisher: AnyPublisher<NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, FilmsCollectionViewItem>, Never> { get }
    
    func start()
}

// MARK: - Class

final class FilmsViewModel: FilmViewModelProtocol {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<FilmsCollectionViewSection, FilmsCollectionViewItem>

    @Published private var mostRatedFilms: [MostRatedFilmViewModel] = []
    @Published private var allFilms: [Film] = []
    @Published private var filmImage: UIImage?
        
    var dataSourcePublisher: AnyPublisher<Snapshot, Never> {
        Publishers.CombineLatest($mostRatedFilms, $allFilms)
            .map { self.createDataSource(mostRatedFilms: $0, allFilms: $1) }
            .eraseToAnyPublisher()
    }
    
    private let filmsUseCase: FilmsUseCaseProtocol
    private let imageLoaderUseCase: ImageLoaderUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(filmsUseCase: FilmsUseCaseProtocol, imageLoaderUseCase: ImageLoaderUseCaseProtocol) {
        self.filmsUseCase = filmsUseCase
        self.imageLoaderUseCase = imageLoaderUseCase
    }
    
    private func createDataSource(mostRatedFilms: [MostRatedFilmViewModel], allFilms: [Film]) -> Snapshot {
        var snapshot = Snapshot()

        if !mostRatedFilms.isEmpty {
            let sectionModel = MostRatedFilmsSectionModel(
                title: "Most Rated"
            )
            let section: FilmsCollectionViewSection = .mostRated(sectionModel)
            snapshot.appendSections([.mostRated(sectionModel)])
            mostRatedFilms.forEach { snapshot.appendItems([.mostRated($0)], toSection: section) }
        }
        
        return snapshot
    }
    
    private func transformToMostRatedFilms(_ films: [Film]) -> [MostRatedFilmViewModel] {
        return films.map { viewModel(from: $0)}.filter { $0.rtScore > 95 }
    }
    
    private func viewModel(from film: Film) -> MostRatedFilmViewModel {
        MostRatedFilmViewModelFactory.create(from: film, imageLoader: { imageString in
            self.imageLoaderUseCase.execute(from: imageString)
        })
    }
    
    func start() {
//        state = .loading
        
        filmsUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    return
//                    self.state = .error(error.localizedDescription)
                }
            }, receiveValue: { films in
                self.allFilms = films
                self.mostRatedFilms = self.transformToMostRatedFilms(films)
//                self.state = films.isEmpty ? .empty : .success(films)
            })
            .store(in: &cancellables)
    }
}
