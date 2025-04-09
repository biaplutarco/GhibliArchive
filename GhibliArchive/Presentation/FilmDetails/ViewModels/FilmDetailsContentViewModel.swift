//
//  FilmDetailsContentViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Combine
import UIKit

// MARK: - Factory

struct FilmDetailsContentViewModelFactory {
    static func create(from film: Film, isFavorite: Bool, imageLoader: (String) -> AnyPublisher<UIImage?, Never>) -> FilmDetailsContentViewModel {
        .init(
            id: film.id,
            title: film.title,
            originalTitle: film.originalTitle,
            description: film.description,
            director: "Director: " + film.director,
            producer: "Producer: " + film.producer,
            subtitle: film.runningTime.formattedTime + " • " + film.releaseDate,
            rtScore: film.rtScore + "%",
            banner: imageLoader(film.banner),
            isFavorite: isFavorite
        )
    }
}

// MARK: - ViewModel

struct FilmDetailsContentViewModel {
    let id: String
    let title: String
    let originalTitle: String
    let description: String
    let director: String
    let producer: String
    let subtitle: String
    let rtScore: String
    let banner: AnyPublisher<UIImage?, Never>
    let isFavorite: Bool
}

extension FilmDetailsContentViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: FilmDetailsContentViewModel, rhs: FilmDetailsContentViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
