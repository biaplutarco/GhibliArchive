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
    private let userDeafaults: FilmUserDefaultsProtocol

    init(userDeafaults: FilmUserDefaultsProtocol) {
        self.userDeafaults = userDeafaults
    }

    func toggleFavorite(_ film: Film) {
        if userDeafaults.isFavorite(film.id) {
            userDeafaults.removeFavorite(film)
        } else {
            userDeafaults.addFavorite(film)
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        userDeafaults.isFavorite(id)
    }
    
    func getFavorites() -> [Film] {
        userDeafaults.getFavorites()
    }
}
