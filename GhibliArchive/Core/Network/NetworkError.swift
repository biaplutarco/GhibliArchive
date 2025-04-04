//
//  APIError.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case apiError(cause: Error, statusCode: Int?)
    case invalidResponse
    case notFound
    case decodingError(Error)
}
