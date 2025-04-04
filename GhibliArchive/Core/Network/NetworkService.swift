//
//  NetworkService.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void)
}
