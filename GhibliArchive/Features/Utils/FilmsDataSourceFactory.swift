//
//  FilmsDataSourceFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

final class FilmsDataSourceFactory {
    typealias PosterFilmsDataSource = UICollectionViewDiffableDataSource<FilmsCollectionViewSection, PosterFilmsCollectionViewItem>
    typealias MostRatedFilmsDataSource = UICollectionViewDiffableDataSource<FilmsCollectionViewSection, MostRatedFilmsCollectionViewItem>
    
    // MARK: - Methods
    
    static func makeMostRatedFilmsDataSource(for collectionView: UICollectionView) -> MostRatedFilmsDataSource {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .mostRatedFilm(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MostRatedFilmCell.reuseIdentifier,
                    for: indexPath
                ) as? MostRatedFilmCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModel)
                return cell
            }
        }
    }
    
    static func makePosterFilmsDataSource(for collectionView: UICollectionView) -> PosterFilmsDataSource {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .posterFilm(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PosterFilmCell.reuseIdentifier,
                    for: indexPath
                ) as? PosterFilmCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModel)
                return cell
            }
        }
    }
}
