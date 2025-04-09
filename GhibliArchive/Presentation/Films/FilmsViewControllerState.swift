//
//  FilmsViewControllerState.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Foundation

enum FilmsViewControllerState {
    case loading
    case error(WarningViewModel)
    case success(mostRatedSnapshot: MostRatedFilmsSnapshot, posterFilmSnapshot: PosterFilmsSnapshot)
    case searched(PosterFilmsSnapshot)
    case willSearch(PosterFilmsSnapshot)
    case emptySearched(String)
}

extension FilmsViewControllerState: Equatable {
    static func == (lhs: FilmsViewControllerState, rhs: FilmsViewControllerState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.searched, .searched): return true
        case (.error, .error): return true
        default: return false
        }
    }
}
