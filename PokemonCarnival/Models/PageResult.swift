//
//  PageResult.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Foundation

struct PageResult<T: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
    
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [T]
}
