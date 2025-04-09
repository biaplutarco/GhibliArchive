//
//  FilmsDataSourceFactory.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

// MARK: - Enum

enum FilmsCollectionViewSection: Hashable {
    case unique
}

// MARK: - Factory

final class FilmsDataSourceFactory {
    typealias PosterFilmsDataSource = UICollectionViewDiffableDataSource<FilmsCollectionViewSection, PosterFilmViewModel>
    typealias MostRatedFilmsDataSource = UICollectionViewDiffableDataSource<FilmsCollectionViewSection, MostRatedFilmViewModel>
    
    // MARK: - Methods
    
    static func makeMostRatedFilmsDataSource(for collectionView: UICollectionView) -> MostRatedFilmsDataSource {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MostRatedFilmCell.reuseIdentifier,
                for: indexPath
            ) as? MostRatedFilmCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        }
    }
    
    static func makePosterFilmsDataSource(for collectionView: UICollectionView) -> PosterFilmsDataSource {
        return .init(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterFilmCell.reuseIdentifier,
                for: indexPath
            ) as? PosterFilmCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        }
    }
}
