//
//  UserDefaultService.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

protocol FilmUserDefaultsProtocol {
    func addFavorite(_ film: Film)
    func removeFavorite(_ film: Film)
    func isFavorite(_ id: String) -> Bool
    func getFavorites() -> [Film]
}

final class FilmUserDefaults: FilmUserDefaultsProtocol {
    private let key = "favoriteFilms"
    private let defaults = UserDefaults.standard

    func addFavorite(_ film: Film) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.id == film.id }) else { return }
        favorites.append(film)
        save(favorites)
    }

    func removeFavorite(_ film: Film) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == film.id }
        save(favorites)
    }

    func isFavorite(_ id: String) -> Bool {
        getFavorites().contains(where: { $0.id == id })
    }

    func getFavorites() -> [Film] {
        guard let data = defaults.data(forKey: key) else { return [] }
        let films = try? JSONDecoder().decode([Film].self, from: data)
        return films ?? []
    }

    private func save(_ favorites: [Film]) {
        if let data = try? JSONEncoder().encode(favorites) {
            defaults.set(data, forKey: key)
        }
    }
}
