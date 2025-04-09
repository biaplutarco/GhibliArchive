//
//  ViewController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Combine
import UIKit

final class FilmsViewController: StatefulViewController {
    
    // MARK: - Properties
    private let viewModel: FilmViewModelProtocol
    private let router: FilmsRouterProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    private lazy var mostRatedFilmsDataSource = FilmsDataSourceFactory.makeMostRatedFilmsDataSource(for: .init())
    private lazy var allFilmsDataSource = FilmsDataSourceFactory.makePosterFilmsDataSource(for: .init())
    private lazy var searchedFilmsDataSource = FilmsDataSourceFactory.makePosterFilmsDataSource(for: searchedFilmsCollectionView)
    
    // MARK: - UI Components
    
    private lazy var favoritesButton: UIBarButtonItem = {
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "heart.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapFavorites)
        )
        favoritesButton.tintColor = .ghibliBlue
        return favoritesButton
    }()
    
    private lazy var infoButton: UIBarButtonItem = {
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapFavorites)
        )
        favoritesButton.tintColor = .ghibliBlue
        return favoritesButton
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var searchedFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterFilmCell.self, forCellWithReuseIdentifier: PosterFilmCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var filmsContentView: FilmsContentView = {
        let contentView = FilmsContentView()
        contentView.delegate = self
        contentView.configure()
        return contentView
    }()


    // MARK: - Init
    
    init(viewModel: FilmViewModelProtocol, router: FilmsRouterProtocol) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup(with: [filmsContentView])
        
        subscribeToState()
        publisherToSearch()
        subscribeToNagivate()
        
        viewModel.start()
    }
    
    // MARK: - UI Logics

    private func showSearchedFilms() {
        view.addSubview(searchedFilmsCollectionView)
        searchedFilmsCollectionView.fillToSuperview()
    }
    
    private func removeSearchedFilms() {
        searchedFilmsCollectionView.removeFromSuperview()
    }
    
    private func renderSuccess(with mostRatedSnapshot: MostRatedFilmsSnapshot, and posterFilmSnapshot: PosterFilmsSnapshot) {
        stopLoading()
        removeWarningView()
        mostRatedFilmsDataSource.apply(mostRatedSnapshot, animatingDifferences: true)
        allFilmsDataSource.apply(posterFilmSnapshot, animatingDifferences: true)
    }
    
    private func renderSeach(with posterFilmsSnapshot: PosterFilmsSnapshot) {
        showSearchedFilms()
        searchedFilmsDataSource.apply(posterFilmsSnapshot, animatingDifferences: true)
    }
    
    private func render(_ state: FilmsViewControllerState) {
        switch state {
        case .error(let viewModel):
            stopLoading()
            showWarningView(with: viewModel)
        case .loading:
            startLoading()
        case .success(let mostRatedSnapshot, let posterFilmSnapshot):
            renderSuccess(with: mostRatedSnapshot, and: posterFilmSnapshot)
        case .searched(let snapshot):
            renderSeach(with: snapshot)
        case .willSearch(let snapshot):
            renderSeach(with: snapshot)
        case .emptySearched:
            return // TODO: tratar
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapFavorites() {
        viewModel.didTapFavorites()
    }

    // MARK: - Setup Bindings
    
    private func publisherToSearch() {
        SearchBarAdapter.bindSearchTextPublisher(
            from: searchController.searchBar,
            to: viewModel.searchTextPublisher,
            storeIn: &cancellables
        )
    }
    
    private func subscribeToState() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToNagivate() {
        viewModel.onNavigateToFilmDetailsPublisher
            .sink { [weak self] filmId in
                self?.router.goToFilmDetails(with: filmId)
            }
            .store(in: &cancellables)
        viewModel.onNavigateToFavoritesPublisher
            .sink { [weak self] in
                self?.router.goToFavorites()
            }
            .store(in: &cancellables)

    }
}

// MARK: - ViewCodable

extension FilmsViewController: ViewCodable {
    func additionalSetup() {
        title = "Films"
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = favoritesButton
        navigationItem.leftBarButtonItem = infoButton
        
        warningView.delegate = self
    }
    
    func setupConstraints() {
        filmsContentView.fillToSuperview()
    }
}

// MARK: - FilmsContentViewDelegate

extension FilmsViewController: FilmsContentViewDelegate {
    func collectionType(_ type: FilmsContentView.CollectionType, didSelectItemAt indexPath: IndexPath) {
        switch type {
        case .allFilms:
            guard let id = allFilmsDataSource.itemIdentifier(for: indexPath)?.id else {
                return
            }
            viewModel.didSelectFilm(with: id)
        case .mostRated:
            guard let id = mostRatedFilmsDataSource.itemIdentifier(for: indexPath)?.id else {
                return
            }
            viewModel.didSelectFilm(with: id)
        }
    }
    
    func setMostRatedFilmsDataSource(to collectionView: UICollectionView) {
        let datasource = FilmsDataSourceFactory.makeMostRatedFilmsDataSource(for: collectionView)
        mostRatedFilmsDataSource = datasource
    }
    
    func setAllFilmsDataSource(to collectionView: UICollectionView) {
        let datasource = FilmsDataSourceFactory.makePosterFilmsDataSource(for: collectionView)
        allFilmsDataSource = datasource
    }
}

// MARK: - UICollectionViewDelegate

extension FilmsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 8, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.itemSize(itemsPerRow: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = searchedFilmsDataSource.itemIdentifier(for: indexPath)?.id else {
            return
        }
        viewModel.didSelectFilm(with: id)
    }
}

// MARK: - UISearchBarDelegate

extension FilmsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        startLoading()
        viewModel.searchBarDidBeginEditing()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchedFilms()
        stopLoading()
    }
}

// MARK: - WarningViewDelegate

extension FilmsViewController: WarningViewDelegate {
    func didTapButton() {
        removeWarningView()
        startLoading()
        viewModel.tryAgain()
    }
}
