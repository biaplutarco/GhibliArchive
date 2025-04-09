//
//  MockFavoritesUseCase.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Combine
@testable import GhibliArchive

final class MockFavoritesUseCase: FavoritesFilmUseCasaProtocol {
    var favoriteFilms: [Film] = []
    var isFavorite: Bool = false

    func isFavorite(_ id: String) -> Bool {
        isFavorite
    }

    func toggleFavorite(_ film: Film) { }
    
    func getFavorites() -> [Film] {
        return favoriteFilms
    }
}
