//
//  Endpoint.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

// MARK: - Enums

enum HTTPMethod: String {
    case get = "GET"
}

// MARK: - Protocol

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    func getURL() -> URL?
}

extension Endpoint {
    func getURL() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = baseURL
        component.path = path
        return component.url
    }
}

// MARK: - FilmEndpoint

enum FilmEndpoint: Endpoint {
    case getFilms
    case getFilmBy(id: String)
    
    var baseURL: String {
        switch self {
        case .getFilmBy( _), .getFilms:
            return "ghibliapi.vercel.app"
        }
    }
    
    var path: String {
        switch self {
        case .getFilms:
            return "/films"
        case .getFilmBy(let id):
            return "/films/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getFilmBy( _), .getFilms:
            return .get
        }
    }
}
