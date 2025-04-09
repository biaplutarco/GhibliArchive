//
//  PosterFilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Combine
import UIKit

// MARK: - Factory

struct PosterFilmViewModelFactory {
    static func create(from film: Film, imageLoader: (String) -> AnyPublisher<UIImage?, Never>) -> PosterFilmViewModel {
        .init(
            id: film.id,
            poster: imageLoader(film.image)
        )
    }
}

// MARK: - ViewModel

struct PosterFilmViewModel {
    let id: String
    let poster: AnyPublisher<UIImage?, Never>
}

extension PosterFilmViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: PosterFilmViewModel, rhs: PosterFilmViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
