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

protocol FilmsCollectionViewItemProtocol: Hashable {
    var filmID: String { get }
}

extension FilmsCollectionViewItemProtocol {
    func hash(into hasher: inout Hasher) {
        hasher.combine(filmID)
    }
    static func == (lhs: any FilmsCollectionViewItemProtocol, rhs: any FilmsCollectionViewItemProtocol) -> Bool {
        return lhs.filmID == rhs.filmID
    }
}

enum MostRatedFilmsCollectionViewItem: Hashable {
    case mostRatedFilm(MostRatedFilmViewModel)
}

enum PosterFilmsCollectionViewItem: Hashable {
    case posterFilm(PosterFilmViewModel)
}
