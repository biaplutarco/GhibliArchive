//
//  NetworkServiceProtocol.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import UIKit
import Combine

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}

protocol Cacheable {
   func cacheData(_ data: Data, for key: String)
}

// MARK: - Class

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let url = endpoint.getURL() else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap{ output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                if httpResponse.statusCode == 404 {
                    throw NetworkError.notFound
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.requestFailed(httpResponse.statusCode)
                }
                
                let cachedResponse = CachedURLResponse(response: httpResponse, data: output.data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error in
                NetworkError.invalidJSON(String(describing: error))
            }
            .eraseToAnyPublisher()
    }
    
    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        return session.dataTaskPublisher(for: url)
            .map { data, _ in UIImage(data: data) }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
