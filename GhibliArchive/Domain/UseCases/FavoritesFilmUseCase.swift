//
//  FavoritesFilmUseCase.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation

protocol FavoritesFilmUseCasaProtocol {
    func toggleFavorite(_ film: Film)
    func isFavorite(_ id: String) -> Bool
    func getFavorites() -> [Film]
}

final class FavoritesFilmUseCase: FavoritesFilmUseCasaProtocol {
    private let userDefaults: FilmUserDefaultsProtocol

    init(userDefaults: FilmUserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }

    func toggleFavorite(_ film: Film) {
        if userDefaults.isFavorite(film.id) {
            userDefaults.removeFavorite(film)
        } else {
            userDefaults.addFavorite(film)
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        userDefaults.isFavorite(id)
    }
    
    func getFavorites() -> [Film] {
        userDefaults.getFavorites()
    }
}
