//
//  NetworkError.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case notFound
    case requestFailed(Int)
    case invalidJSON(String)
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.notFound, .notFound): return true
        case (.requestFailed, .requestFailed): return true
        case (.invalidJSON, .invalidJSON): return true
            
        default: return false
        }
    }
}
