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
        if let id = pokemon.id {
            itemId = Int32(id)
        }
        name = pokemon.name
        url = pokemon.url
        if let like = pokemon.isLiked {
            self.isLiked = like
        }
    }
}
