//
//  JSONDecoding.swift
//  GhibliArchive
//
//  Created by Beatriz Plutarco on 03/04/25.
//

import Foundation

protocol JSONDecoding {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: JSONDecoding { }
