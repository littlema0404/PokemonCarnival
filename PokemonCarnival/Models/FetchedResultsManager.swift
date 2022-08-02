//
//  FetchedResultsManager.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import CoreData

protocol FetchedResultsManagerDelegate: AnyObject {
    associatedtype Object: NSManagedObject
    
    func managerDidUpdateObject(_ object: Object)
}

class FetchedResultsManager<T, D: FetchedResultsManagerDelegate>: NSObject, NSFetchedResultsControllerDelegate where D.Object == T {
    private let fetcher: ManagedObjectsFetcher<T>
    
    weak var delegate: D?
    
    init(fetcher: ManagedObjectsFetcher<T>) {
        self.fetcher = fetcher
        
        super.init()
        
        fetcher.controller.delegate = self
    }
    
    func fetchedObjects() -> [T] {
        fetcher.fetchedObjects()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .update:
            delegate?.managerDidUpdateObject(anObject as! D.Object)
        default:
            break
        }
    }
}
