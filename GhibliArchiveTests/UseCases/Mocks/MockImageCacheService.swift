//
//  MockImageCacheService.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import UIKit

@testable import GhibliArchive

final class SpyImageCacheService: ImageCacheServiceProtocol {
    var cache: [URL: UIImage] = [:]

    private(set) var getImageCalled = false
    private(set) var saveImageCalled = false
    private(set) var savedImage: UIImage?
    private(set) var savedURL: URL?

    func getImage(for url: URL) -> UIImage? {
        getImageCalled = true
        return cache[url]
    }

    func saveImage(_ image: UIImage, for url: URL) {
        saveImageCalled = true
        savedImage = image
        savedURL = url
        cache[url] = image
    }
}

