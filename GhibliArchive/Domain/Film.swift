//
//  Film.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

struct Film: Codable {
    let id: String
    let title: String
    let originalTitle: String
    let description: String
    let director: String
    let producer: String
    let runningTime: String
    let rtScore: String
    let image: String
    let banner: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case description
        case director
        case producer
        case runningTime = "running_time"
        case rtScore = "rt_score"
        case image
        case banner = "movie_banner"
        case releaseDate = "release_date"
    }
}
