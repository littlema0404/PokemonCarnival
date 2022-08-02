//
//  ManagedObjectsFetcher.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import CoreData

class ManagedObjectsFetcher<T: NSManagedObject> {
    let controller: NSFetchedResultsController<T>
    
    func fetchedObjects() -> [T] {
        controller.fetchedObjects ?? []
    }

    init(fetchRequest: NSFetchRequest<T>, sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil, in context: NSManagedObjectContext = .default) {
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try? controller.performFetch()
    }
}
