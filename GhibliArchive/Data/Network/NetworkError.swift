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
