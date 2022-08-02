//
//  Pokemon.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Foundation

struct Pokemon: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case height
        case weight
        case types
    }
    
    var id: Int
    var name: String?
    var height: Double?
    var weight: Double?
    var types: [ItemType]?
    
    var isLiked: Bool? {
        didSet {
            guard let isLiked = isLiked, isLiked != oldValue else { return }
            
            let managedPokenmon = ManagedPokenmon.findFirstOrCreate(id: id)
            managedPokenmon.isLiked = isLiked
            managedPokenmon.saveToDefaultContext()
        }
    }
    
    init(id: Int) {
        self.id = id
    }
    
    init(managedPokenmon: ManagedPokenmon) {
        id = Int(managedPokenmon.itemId)
        name = managedPokenmon.name
        height = managedPokenmon.height
        weight = managedPokenmon.weight
        isLiked = managedPokenmon.isLiked
        types = managedPokenmon.types?.compactMap { $0 as? String }.map { ItemType(name: $0) }
    }
}

extension Pokemon: Saveable {
    func saveToCoreData() {
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
