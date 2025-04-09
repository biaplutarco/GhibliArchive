//
//  FavoritesViewController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine
import UIKit

final class FavoritesViewController: StatefulViewController {
    // MARK: - Properties
    
    private let viewModel: FavoritesViewModelProtocol
    private let router: FavoritesRouterProtocol
    
    private lazy var dataSource = FilmsDataSourceFactory.makePosterFilmsDataSource(for: collectionView)
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterFilmCell.self, forCellWithReuseIdentifier: PosterFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
        
    // MARK: - Inits
    
    init(viewModel: FavoritesViewModelProtocol, router: FavoritesRouterProtocol) {
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
        
        collectionView.dataSource = dataSource
        
        subscribeToState()
        subscribeToNagivate()
        
        setup(with: [collectionView])
        
        viewModel.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .ghibliBlue
    }
    
    // MARK: - Setup DataSource

    private func render(_ state: FavoritesViewControllerState) {
        switch state {
        case .empty(let message):
            stopLoading()
            showWarningView(with: message)
        case .loading:
            startLoading()
        case .films(let snapshot):
            stopLoading()
            removeWarningView()
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: - Setup Bindings
    
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
        viewModel.onNavigateToRootViewController
            .sink { [weak self] _ in
                self?.router.goBack()
            }
            .store(in: &cancellables)
    }
}

extension FavoritesViewController: ViewCodable {
    func setupConstraints() {
        collectionView.fillToSuperview()
    }
    
    func additionalSetup() {
        title = "Favorites"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .ghibliBlue
        
        warningView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 8, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.itemSize(itemsPerRow: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath)?.id else {
            return
        }
        viewModel.didSelectFilm(with: id)
    }
}

// MARK: - WarningViewDelegate

extension FavoritesViewController: WarningViewDelegate {
    func didTapButton() {
        removeWarningView()
        startLoading()
        viewModel.didTapExplore()
    }
}
