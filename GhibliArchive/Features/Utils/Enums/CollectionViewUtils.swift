//
//  CollectionViewUtils.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Foundation

// MARK: - Section

enum FilmsCollectionViewSection: Hashable {
    case unique
}
// MARK: - Section Items

enum MostRatedFilmsCollectionViewItem: Hashable {
    case mostRatedFilm(MostRatedFilmViewModel)
}

enum PosterFilmsCollectionViewItem: Hashable {
    case posterFilm(PosterFilmViewModel)
}
