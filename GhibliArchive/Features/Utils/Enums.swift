//
//  Enums.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 06/04/25.
//

import Combine

enum FilmsViewControllerState {
    case idle
    case empty
    case loading
    case error(String)
    case success
}

extension FilmsViewControllerState: Equatable {
    static func == (lhs: FilmsViewControllerState, rhs: FilmsViewControllerState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.empty, .empty): return true
        case (.error, .error): return true
        default: return false
        }
    }
}

typealias FilmsViewModelOuput = AnyPublisher<FilmsViewControllerState, Never>

// MARK: - Section

enum FilmsCollectionViewSection: Hashable {
    case main
}
// MARK: - Section Item

enum FilmsCollectionViewItem: Hashable {
    case film(MostRatedFilmViewModel)
}
