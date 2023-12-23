//
//  PersistentContainer.swift
//  Scratch
//
//  Created by Andrew Ingraham on 11/16/23.
//

// subclass of NSPersistentContainer
// NSPersistentContainer simplifies the creation and management of the Core Data stack by handling the creation of the managed object model (NSManagedObjectModel), persistent store coordinator (NSPersistentStoreCoordinator), and the managed object context (NSManagedObjectContext).

import Foundation
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    } // saveContext(backgroundContext: NSManagedObjectContext? = nil) This function should save the background context
}
