//
//  FilmDetailsViewControllerState.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

enum FilmDetailsViewControllerState {
    case loading
    case error(WarningViewModel)
    case success(FilmDetailsContentViewModel)
    case alert(String)
}

extension FilmDetailsViewControllerState: Equatable {
    static func == (lhs: FilmDetailsViewControllerState, rhs: FilmDetailsViewControllerState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.error, .error): return true
        case (.alert, .alert): return true
        default: return false
        }
    }
}
