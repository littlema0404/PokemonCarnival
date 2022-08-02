//
//  Pokemon.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Foundation

struct Pokemon: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    var name: String?
    var url: String?
    var isLiked: Bool? {
        didSet {
            guard let isLiked = isLiked,
                  isLiked != oldValue,
                  let id = id else { return }
            
            let managedPokenmon = ManagedPokenmon.findFirstOrCreate(id: id)
            managedPokenmon.isLiked = isLiked
            managedPokenmon.saveToDefaultContext()
        }
    }
    
    var id: String? {
        url.flatMap { URL(string: $0) }?.lastPathComponent
    }
}

extension Pokemon: Saveable {
    func saveToCoreData() {
        guard let id = id else { return }
        let managedPokemon = ManagedPokenmon.findFirstOrCreate(id: id)
        managedPokemon.configure(with: self)
        managedPokemon.saveToDefaultContext()
    }
}
