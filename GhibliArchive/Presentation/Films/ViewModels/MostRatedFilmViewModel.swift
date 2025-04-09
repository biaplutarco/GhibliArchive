//
//  MostRatedFilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 05/04/25.
//

import Combine
import UIKit

// MARK: - Factory

struct MostRatedFilmViewModelFactory {
    static func create(from film: Film, imageLoader: (String) -> AnyPublisher<UIImage?, Never>) -> MostRatedFilmViewModel {
        .init(
            id: film.id,
            title: film.title,
            originalTitle: film.originalTitle,
            subtitle: film.runningTime.formattedTime + " • " + film.releaseDate,
            rtScore: Int(film.rtScore) ?? .zero,
            poster: imageLoader(film.image),
            wasWatched: false
        )
    }
}

// MARK: - ViewModel

struct MostRatedFilmViewModel {
    let id: String
    let title: String
    let originalTitle: String
    let subtitle: String
    let rtScore: Int
    let poster: AnyPublisher<UIImage?, Never>
    let wasWatched: Bool
}

extension MostRatedFilmViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MostRatedFilmViewModel, rhs: MostRatedFilmViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
