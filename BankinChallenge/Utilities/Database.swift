//
//  Database.swift
//  BankinChallenge
//
//  Created by Jason Pierna on 22/02/2022.
//

import Foundation
import CoreData

class Database {
    static var shared = Database()
    
    private var container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    private init() {
        container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData loadPersistentStores error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func loadAll<T: NSManagedObject>(_ type: T.Type) -> [T] {
        let entityName = String(describing: T.self)
        print("Core Data - Loading \(entityName)")
        
        do {
            let request = NSFetchRequest<T>(entityName: entityName)
            request.predicate = nil
            request.sortDescriptors = []
            
            return try context.fetch(request)
        } catch {
            print("Core Data - Loading \(entityName) - Error \(error.localizedDescription)")
            return []
        }
    }
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Core Data - Save Error - \(error.localizedDescription)")
        }
    }
}
