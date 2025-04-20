//
//  CoreDataStack.swift
//  SimpleAuth
//
//  Created by MaxBook on 4/19/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    
    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext
    
    private init() {
        let container = NSPersistentContainer(name: "SimpleAuth")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        
        persistentContainer = container
        context = container.viewContext
    }
    
    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
}
