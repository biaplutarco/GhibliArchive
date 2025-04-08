//
//  MostRatedFilmViewModel.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 05/04/25.
//

import Combine
import UIKit

extension String {
    var formattedTime: String {
        guard let totalMinutes = Int(self) else { return self }

        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        var components: [String] = []

        if hours > 0 {
            components.append("\(hours) hour" + (hours > 1 ? "s" : ""))
        }

        if minutes > 0 {
            components.append("\(minutes) minute" + (minutes > 1 ? "s" : ""))
        }

        return components.isEmpty ? "0 minutes" : components.joined(separator: " and ")
    }
}

// MARK: - Factory

struct MostRatedFilmViewModelFactory {
    static func create(from film: Film, imageLoader: (String) -> AnyPublisher<UIImage?, Never>) -> MostRatedFilmViewModel {
        .init(
            id: film.id,
            title: film.title,
            originalTitle: film.originalTitle,
            runningTime: film.runningTime.formattedTime,
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
    let runningTime: String
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
