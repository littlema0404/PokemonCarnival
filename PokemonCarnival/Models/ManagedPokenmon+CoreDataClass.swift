//
//  ManagedPokenmon+CoreDataClass.swift
//  
//
//  Created by littlema on 2022/8/1.
//
//

import Foundation
import CoreData

@objc(ManagedPokenmon)
public class ManagedPokenmon: NSManagedObject {
    static func query(id: Int) -> ManagedPokenmon? {
        let request = ManagedPokenmon.fetchRequest()
        let predicate = NSPredicate(format: "%K == %i", #keyPath(ManagedPokenmon.itemId), id)
        request.predicate =  predicate
        do {
            return try NSManagedObjectContext.default.fetch(request).first
        } catch {
            return nil
        }
    }
    
    static func findFirstOrCreate(id: Int) -> ManagedPokenmon {
        if let managedPokenmon = query(id: id) {
            return managedPokenmon
        } else {
            let managedPokenmon = ManagedPokenmon(context: NSManagedObjectContext.default)
            managedPokenmon.itemId = Int32(id)
            return managedPokenmon
        }
    }

    func configure(with pokemon: Pokemon) {
        itemId = Int32(pokemon.id)
        name = pokemon.name
        if let height = pokemon.height {
            self.height = height
        }
        if let weight = pokemon.weight {
            self.weight = weight
        }
        if let like = pokemon.isLiked {
            self.isLiked = like
        }
        types = NSArray(array: pokemon.types?.compactMap { $0.name } ?? [])
    }
}
