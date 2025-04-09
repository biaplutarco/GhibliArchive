//
//  Film+Fixture.swift
//  GhibliArchiveTests
//
//  Created by Beatriz Plutarco on 08/04/25.
//

import Foundation
@testable import GhibliArchive

extension Film {
    static func fixture(
        id: String = .init(),
        title: String = .init(),
        originalTitle: String = .init(),
        description: String = .init(),
        director: String = .init(),
        producer: String = .init(),
        runningTime: String = .init(),
        rtScore: String = .init(),
        image: String = .init(),
        banner: String = .init(),
        releaseDate: String = .init()
    ) -> Film {
        .init(
            id: id,
            title: title,
            originalTitle: originalTitle,
            description: description,
            director: director,
            producer: producer,
            runningTime: runningTime,
            rtScore: rtScore,
            image: image,
            banner: banner,
            releaseDate: releaseDate
        )
    }
}
