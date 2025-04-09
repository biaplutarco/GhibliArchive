//
//  SpyFavoritesUseCase.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Combine
@testable import GhibliArchive

final class SpyFavoritesUseCase: FavoritesFilmUseCasaProtocol {
    var favoriteFilms: [Film] = []
    var favoriteIDs: Set<String> = []
    
    private(set) var isFavoriteCalled = false
    private(set) var toggleFavoriteeCalled = false
    private(set) var getFavoritesCalled = false
    private(set) var toggleFavoriteCalledWith: Film?

    func isFavorite(_ id: String) -> Bool {
        isFavoriteCalled = true
        return favoriteIDs.contains(id)
    }

    func toggleFavorite(_ film: Film) {
        toggleFavoriteeCalled = true
        toggleFavoriteCalledWith = film
    }
    
    func getFavorites() -> [Film] {
        getFavoritesCalled = true
        return favoriteFilms
    }
}
