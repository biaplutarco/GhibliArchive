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
    private let viewModel: FilmViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    private lazy var mostRatedFilmsDataSource = createMostRatedFilmsDataSource()
    private lazy var allFilmsDataSource = createAllFilmsDataSource()
    private lazy var searchedFilmsDataSource = createSearchedFilmsDataSource()
    
    // MARK: - UI Components
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.center = view.center
        indicatorView.color = .gray
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var mostRatedFilmsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.layer.opacity = 0.6
        label.textColor = .label
        label.text = "Most rated"
        return label
    }()
    
    private lazy var allFilmsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.layer.opacity = 0.6
        label.textColor = .label
        label.text = "All films"
        return label
    }()
    
    private lazy var mostRatedFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MostRatedFilmCell.self, forCellWithReuseIdentifier: MostRatedFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var allFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterFilmCell.self, forCellWithReuseIdentifier: PosterFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var searchedFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterFilmCell.self, forCellWithReuseIdentifier: PosterFilmCell.reuseIdentifier)
        collectionView.delegate = self
        return collectionView
    }()


    // MARK: - Init
    
    init(viewModel: FilmViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    
        mostRatedFilmsCollectionView.dataSource = mostRatedFilmsDataSource
        allFilmsCollectionView.dataSource = allFilmsDataSource
        searchedFilmsCollectionView.dataSource = searchedFilmsDataSource

        setup(with: [
            mostRatedFilmsLabel,
            mostRatedFilmsCollectionView,
            allFilmsLabel,
            allFilmsCollectionView
        ])
        
        subscribeToSnapshot()
        publisherToSearch()
        
        startLoading()
        viewModel.start()
    }
    
    // MARK: - UI Logics
    
    private func startLoading() {
        activityIndicatorView.startAnimating()
        isHiddenContent(true)
    }
    
    private func stopLoading() {
        activityIndicatorView.stopAnimating()
        isHiddenContent(false)
    }
    
    private func showSearchedFilms() {
        view.addSubview(searchedFilmsCollectionView)
        searchedFilmsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchedFilmsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchedFilmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchedFilmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchedFilmsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func isHiddenContent(_ isHidden: Bool) {
        mostRatedFilmsCollectionView.isHidden = isHidden
        allFilmsCollectionView.isHidden = isHidden
        mostRatedFilmsLabel.isHidden = isHidden
        allFilmsLabel.isHidden = isHidden
    }
    
    // MARK: - Setup DataSource

    private func createMostRatedFilmsDataSource() -> DataSource{
      .init(collectionView: mostRatedFilmsCollectionView) { collectionView, indexPath, item in
          switch item {
          case .film(let viewModel):
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostRatedFilmCell.reuseIdentifier, for: indexPath) as? MostRatedFilmCell else {
                  return .init()
              }
              cell.configure(with: viewModel)
              return cell
          }
      }
    }
    
    private func createAllFilmsDataSource() -> DataSource {
      .init(collectionView: allFilmsCollectionView) { collectionView, indexPath, item in
          switch item {
          case .film(let viewModel):
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterFilmCell.reuseIdentifier, for: indexPath) as? PosterFilmCell else {
                  return .init()
              }
              cell.configure(with: viewModel)
              return cell
          }
      }
    }
    
    private func createSearchedFilmsDataSource() -> DataSource {
        .init(collectionView: searchedFilmsCollectionView) { collectionView, indexPath, item in
            switch item {
            case .film(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterFilmCell.reuseIdentifier, for: indexPath) as? PosterFilmCell else {
                    return .init()
                }
                cell.configure(with: viewModel)
                return cell
            }
        }
    }

    // MARK: - Setup Bindings
    
    private func publisherToSearch() {
        let publisher = NotificationCenter.default.publisher(
            for: UISearchTextField.textDidChangeNotification,
            object: searchController.searchBar.searchTextField
        )
        publisher
            .compactMap { ($0.object as? UISearchTextField)?.text}
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.searchTextPublisher.send(text)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToSnapshot() {
        viewModel.mostRatedDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                self.mostRatedFilmsDataSource.apply(snapshot, animatingDifferences: true)
                self.stopLoading()
            })
            .store(in: &cancellables)
        
        viewModel.posterFilmDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                self.allFilmsDataSource.apply(snapshot, animatingDifferences: true)
                self.stopLoading()
            })
            .store(in: &cancellables)
        
        viewModel.searchedFilmDataSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] snapshot in
                guard let self = self else {
                    return
                }
                self.searchedFilmsDataSource.apply(snapshot, animatingDifferences: true)
            })
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
        searchController.isActive = true
        
        view.addSubview(activityIndicatorView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mostRatedFilmsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mostRatedFilmsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            mostRatedFilmsCollectionView.topAnchor.constraint(equalTo: mostRatedFilmsLabel.bottomAnchor),
            mostRatedFilmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mostRatedFilmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mostRatedFilmsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            allFilmsLabel.topAnchor.constraint(equalTo: mostRatedFilmsCollectionView.bottomAnchor, constant: 8),
            allFilmsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            allFilmsCollectionView.topAnchor.constraint(equalTo: allFilmsLabel.bottomAnchor),
            allFilmsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            allFilmsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            allFilmsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            allFilmsCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension FilmsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == allFilmsCollectionView {
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            return .init(top: 0, left: 8, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == searchedFilmsCollectionView {
            let itemsPerRow: CGFloat = 3
            let spacing: CGFloat = 16
            let totalSpacing = spacing * (itemsPerRow + 1)
            let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
            return CGSize(width: width, height: width * 1.4) // exemplo
        } else {
            // Deixa vazio ou retorna .zero se quiser segurança extra
            return .zero
        }
    }
    
//        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            // Ação ao selecionar um item
//            let selectedFilm = viewModel.films[indexPath.item]
//            // Exemplo: navegação ou exibição de detalhes
//            print("Selected Film: \(selectedFilm.title)")
//        }
}

// MARK: - UISearchBarDelegate

extension FilmsViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isHiddenContent(true)
        showSearchedFilms()
        viewModel.searchBarDidBeginEditing()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        stopLoading()
        searchedFilmsCollectionView.removeFromSuperview()
    }
}
