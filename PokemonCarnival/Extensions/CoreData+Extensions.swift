//
//  CoreData+Extensions.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/1.
//

import CoreData

extension NSPersistentContainer {
    static var `default`: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PokemonCarnival")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension NSManagedObjectContext {
    static var `default`: NSManagedObjectContext {
        NSPersistentContainer.default.viewContext
    }
}

extension NSManagedObject {
    @discardableResult
    func saveToDefaultContext() -> Bool {
        let defaultContext = NSManagedObjectContext.default
        if defaultContext.hasChanges {
            do {
                try defaultContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
