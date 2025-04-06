//
//  UserDefaultsFilmRepository.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 04/04/25.
//

import Foundation

final class UserDefaultsFilmRepository: FilmRepository {
    var userDefaults: UserDefaults = .standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func create(_ film: Film) async throws {
        var films = try fetchFilms()
        films.append(film)
        try store(films: films)
    }
    
    func deleteFilm(for id: String) async throws {
        var films = try fetchFilms()
        films.removeAll(where: { $0.id == id })
        try store(films: films)
    }
    
    func find(id: String) async throws -> Film? {
        try fetchFilms().first(where: { $0.id == id })
    }
    
    func fetchFilms() throws -> [Film] {
        guard let filmsData = userDefaults.object(forKey: "films") as? Data else {
            return []
        }
        return try decoder.decode([Film].self, from: filmsData)
    }
    
    private func store(films: [Film]) throws {
        let filmsData = try encoder.encode(films)
        userDefaults.set(filmsData, forKey: "films")
    }
}
