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
        case sprites
    }
    
    var id: Int
    var name: String?
    var height: Double?
    var weight: Double?
    var types: [ItemType]?
    var sprites: Sprites?
    
    var updateLikeVisitor = UpdateLikeVisitor()

    var frontDefaultImage: String? {
        sprites?.frontDefault
    }
    
    var coverImage: String? {
        sprites?.other?.coverImage
    }
    
    var isLiked: Bool? {
        didSet {
            guard let isLiked = isLiked, isLiked != oldValue else { return }
            
            updateLikeVisitor.like = isLiked
            accept(visitor: updateLikeVisitor)
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
        sprites = Sprites(frontDefault: managedPokenmon.frontDefaultImage, other: Other(coverImage: managedPokenmon.coverImage))
    }
}

extension Pokemon: Saveable {
    func saveToCoreData() {
        let managedPokemon = ManagedPokenmon.findFirstOrCreate(id: id)
        managedPokemon.configure(with: self)
        managedPokemon.saveToDefaultContext()
    }
}

extension Pokemon: Likeable {
    @discardableResult
    func accept<V>(visitor: V) -> V.ReturnType where V : ItemVisitor {
        visitor.visitor(from: self)
    }
}

extension Pokemon {
    struct ItemType: Codable {
        enum CodingKeys: String, CodingKey {
            case `type`
            case name
        }
        
        var name: String?
        
        init(name: String) {
            self.name = name
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .type)
            name = try? type?.decode(String.self, forKey: .name)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var type = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .type)
            try type.encode(name, forKey: .name)
        }
    }

    struct Sprites: Codable {
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case other
        }

        var frontDefault: String?
        var other: Other?
    }

    struct Other: Codable {
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
            case coverImage = "front_default"
        }

        var coverImage: String?
        
        init(coverImage: String?) {
            self.coverImage = coverImage
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let officialArtwork = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .officialArtwork)
            coverImage = try? officialArtwork?.decode(String.self, forKey: .coverImage)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            var officialArtwork = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .officialArtwork)
            try officialArtwork.encode(coverImage, forKey: .coverImage)
        }
    }
}
