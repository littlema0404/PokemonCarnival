//
//  Pokemon.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Foundation

struct Pokemon: Codable {
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case name
        case url
        case height
        case weight
        case types
    }
    
    private var _id: Int?
    var name: String?
    var url: String?
    var height: Double?
    var weight: Double?
    var types: [ItemType]?
    
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
    
    var id: Int? {
        _id ?? url.flatMap { URL(string: $0)?.lastPathComponent }.flatMap { Int($0) }
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

extension Pokemon {
    struct ItemType: Codable {
        enum CodingKeys: String, CodingKey {
            case slot
            case `type`
        }
        
        var slot: Int?
        var `type`: TypeContent?
        
        init(name: String) {
            type = TypeContent(name: name, url: nil)
        }
    }
    
    struct TypeContent: Codable {
        enum CodingKeys: String, CodingKey {
            case name
            case url
        }
        
        var name: String?
        var url: String?
    }
}
