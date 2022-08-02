//
//  GenericItem.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import Foundation

struct GenericItem: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }

    var name: String?
    var url: String?
}
