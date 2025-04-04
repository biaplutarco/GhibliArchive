//
//  APIEndpoint.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

enum APIEndpoint {
    case getFilms
    case getFilm(id: Int)

    var url: URL? {
        switch self {
        case .getFilms:
            return URL(string: APIConfig.baseURL + "/films")
        case .getFilm(let id):
            return URL(string: APIConfig.baseURL + "/films/\(id)")
        }
    }
}
