//
//  NetworkError+Equatable.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Foundation
@testable import GhibliArchive

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
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
