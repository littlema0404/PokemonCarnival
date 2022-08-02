//
//  UpdateLikeVisitor.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/3.
//

import Foundation

class UpdateLikeVisitor: ItemVisitor {
    let like: Bool
    
    init(like: Bool) {
        self.like = like
    }
    
    func visitor(from item: Pokemon) -> Bool {
        let managedPokenmon = ManagedPokenmon.findFirstOrCreate(id: item.id)
        managedPokenmon.isLiked = like
        managedPokenmon.saveToDefaultContext()
        return like
    }
}
