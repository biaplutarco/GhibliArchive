//
//  ViewController.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Combine
import UIKit

class FilmsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<FilmsCollectionViewSection, FilmsCollectionViewItem>

    // MARK: - Properties
    private var viewModel: FilmViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    private lazy var dataSource = createDataSource()
    

    // MARK: - UI Components
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Find movies"
        return searchBar
    }()
    
    private lazy var mostRatedFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MostRatedFilmCell.self, forCellWithReuseIdentifier: MostRatedFilmCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var allFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(MostRatedFilmCell.self, forCellWithReuseIdentifier: MostRatedFilmCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()


    // MARK: - Init
    
    init(viewModel: FilmViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        mostRatedFilmsCollectionView.dataSource = dataSource
        subscribeToSnapshot()
        
        viewModel.start()
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Films"
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.searchController = searchBar

        view.addSubview(mostRatedFilmsCollectionView)
        view.addSubview(allFilmsCollectionView)

        NSLayoutConstraint.activate([
            mostRatedFilmsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mostRatedFilmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mostRatedFilmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mostRatedFilmsCollectionView.heightAnchor.constraint(equalToConstant: 250),
            mostRatedFilmsCollectionView.bottomAnchor.constraint(equalTo: allFilmsCollectionView.topAnchor),
            allFilmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allFilmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allFilmsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<FilmsCollectionViewSection, FilmsCollectionViewItem> {
      .init(collectionView: mostRatedFilmsCollectionView) { collectionView, indexPath, item in
          switch item {
          case .mostRated(let viewModel):
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostRatedFilmCell.reuseIdentifier, for: indexPath) as? MostRatedFilmCell else {
                  return .init()
              }
              cell.configure(with: viewModel)
              return cell
          }
      }
    }
    
    private func subscribeToSnapshot() {
        viewModel.dataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                self.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .store(in: &cancellables)
    }


    // MARK: - Setup Bindings

    private func setupBindings() {
//        viewModel.filmsPublisher
//            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
//            .removeDuplicates()
//            .sink { [weak self] films in
//                self?.applySnapshot(films: films)
//            }
//            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension FilmsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 16)
    }
    
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            // Ação ao selecionar um item
//            let selectedFilm = viewModel.films[indexPath.item]
//            // Exemplo: navegação ou exibição de detalhes
//            print("Selected Film: \(selectedFilm.title)")
//        }
}
