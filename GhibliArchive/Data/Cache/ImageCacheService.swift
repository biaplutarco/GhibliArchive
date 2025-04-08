//
//  ImageCacheService.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 07/04/25.
//

import UIKit

// MARK: - Protocol

protocol ImageCacheServiceProtocol {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage, for url: URL)
}

// MARK: - Classe

class ImageCacheService: ImageCacheServiceProtocol {
    private let cache = NSCache<NSURL, UIImage>()

    func getImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func saveImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
