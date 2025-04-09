//
//  ImageLoaderUseCaseTestes.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

 import XCTest
import Combine

@testable import GhibliArchive

final class ImageLoaderUseCaseTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    func makeSut(
        mockNetwork: NetworkServiceProtocol = MockNetworkService(),
        spyCache: ImageCacheServiceProtocol
    ) -> ImageLoaderUseCase {
        return ImageLoaderUseCase(networkService: mockNetwork, cacheService: spyCache)

    }

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func test_execute_returnsCachedImage_whenAvailable() {
        let url = URL(string: "https://example.com/image.png")!
        let cachedImage = UIImage()
        let spyCache = SpyImageCacheService()
        let sut = makeSut(spyCache: spyCache)
        
        spyCache.cache[url] = cachedImage

        let expectation = XCTestExpectation(description: "Return cached image")

        sut.execute(from: url.absoluteString)
            .sink { image in
                XCTAssertEqual(image, cachedImage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_execute_fetchesAndCachesImage_whenNotCached() {
        let url = URL(string: "https://example.com/image.png")!
        let fetchedImage = UIImage()
        let mockNetwork = MockNetworkService()
        let spyCache = SpyImageCacheService()
        let sut = makeSut(mockNetwork: mockNetwork, spyCache: spyCache)
        
        mockNetwork.imageToReturn = fetchedImage

        let expectation = XCTestExpectation(description: "Fetch and cache image")

        sut.execute(from: url.absoluteString)
            .sink { image in
                XCTAssertEqual(image, fetchedImage)
                XCTAssertTrue(spyCache.saveImageCalled)
                XCTAssertEqual(spyCache.savedImage, fetchedImage)
                XCTAssertEqual(spyCache.savedURL, url)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_execute_returnsNil_whenURLIsInvalid() {
        let spyCache = SpyImageCacheService()
        let sut = makeSut(spyCache: spyCache)
        
        let expectation = XCTestExpectation(description: "Return nil for invalid URL")

        sut.execute(from: "notaurl")
            .sink { image in
                XCTAssertNil(image)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_execute_savesImageToCache_whenImageIsFetchedFromNetwork() {
        let urlString = "https://example.com/image.png"
        let url = URL(string: urlString)!
        let networkImage = UIImage()
        let mockNetwork = MockNetworkService()
        let spyCache = SpyImageCacheService()
        let sut = makeSut(mockNetwork: mockNetwork, spyCache: spyCache)

        let expectation = XCTestExpectation(description: "Fetched and cached image")
        mockNetwork.imageToReturn = networkImage
        
        sut.execute(from: urlString)
            .sink { image in
                XCTAssertTrue(spyCache.saveImageCalled)
                XCTAssertEqual(spyCache.savedImage, networkImage)
                XCTAssertEqual(spyCache.savedURL, url)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_execute_doesNotSaveImage_whenImageIsAlreadyCached() {
        let urlString = "https://example.com/image.png"
        let url = URL(string: urlString)!
        let cachedImage = UIImage()
        let spyCache = SpyImageCacheService()
        spyCache.cache[url] = cachedImage

        let sut = makeSut(spyCache: spyCache)

        let expectation = XCTestExpectation(description: "Returned cached image")

        sut.execute(from: urlString)
            .sink { image in
                XCTAssertEqual(image, cachedImage)
                XCTAssertFalse(spyCache.saveImageCalled)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
