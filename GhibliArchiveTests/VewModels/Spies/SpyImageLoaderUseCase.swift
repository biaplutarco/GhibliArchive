//
//  SpyImageLoaderUseCase.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 09/04/25.
//

import Combine
@testable import GhibliArchive
import UIKit

final class SpyImageLoaderUseCase: ImageLoaderUseCaseProtocol {
    private(set) var executeCalled = false
    private(set) var urlPassed: String?
    
    func execute(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        executeCalled = true
        urlPassed = urlString
        return Just(nil).eraseToAnyPublisher()
    }
}
