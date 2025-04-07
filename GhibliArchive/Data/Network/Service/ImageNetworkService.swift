//
//  ImageNetworkService.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import Combine
import UIKit

//// MARK: - Protocol
//
//protocol ImageNetworkServiceProtocol {
//    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never>
//}
//
//// MARK: - Classe
//
//final class ImageNetworkService: ImageNetworkServiceProtocol {
//    private let networkService: NetworkService
//    
//    init(networkService: NetworkService) {
//        self.networkService = networkService
//    }
//    
//    func fetchImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
//        return networkService.fetch(url: url)
//            .map { (response: Data) in
//                UIImage(data: response)
//            }
////            .map { data, _ in UIImage(data: data) }
//            .replaceError(with: nil)
//            .eraseToAnyPublisher()
////        return session.dataTaskPublisher(for: url)
////            .map { data, _ in UIImage(data: data) }
////            .replaceError(with: nil)
////            .eraseToAnyPublisher()
//    }
//}
