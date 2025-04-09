//
//  FavoritesViewControllerState.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

enum FavoritesViewControllerState {
    case empty(WarningViewModel)
    case films(PosterFilmsSnapshot)
    case loading
}

extension FavoritesViewControllerState: Equatable {
    static func == (lhs: FavoritesViewControllerState, rhs: FavoritesViewControllerState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.films, .films): return true
        case (.loading, .loading): return true
        default: return false
        }
    }
}
