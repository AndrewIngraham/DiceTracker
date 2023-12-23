//
//  DataController.swift
//  DiceTracker
//
//  Created by Andrew Ingraham on 11/16/23.
//

import Foundation
import SwiftUI
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.name = "New Item"
            newItem.date = Date()
            newItem.data = [Int]()
            newItem.graphData = Array(repeating: 0, count: 12)
            newItem.gameType = "2Dice"
            newItem.diceType = "physical"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static var previewItem: Item = {
        let viewContext = DataController.preview.container.viewContext
        let previewItem = Item(context: viewContext)
        previewItem.name = "Preview Item"
        previewItem.date = Date()
        previewItem.data = [Int]()
        previewItem.graphData = Array(repeating: 0, count: 12)
        previewItem.gameType = "2Dice"
        previewItem.diceType = "digital"
        
        return previewItem
    }()
    
    static var previewItem2: Item = {
        let viewContext = DataController.preview.container.viewContext
        let previewItem = Item(context: viewContext)
        previewItem.name = "Preview Item"
        previewItem.date = Date()
        previewItem.data = Array(repeating: 10, count: 1000)
        previewItem.graphData = Array(repeating: 0, count: 12)
        previewItem.gameType = "2Dice"
        previewItem.diceType = "physical"
        
        return previewItem
    }()
    
    let container: NSPersistentContainer // Creates a container named "DataModel" that also searched for a related data model that matches the name. A related init() can be used init(name: String, managedObjectModel: NSManagedObjectModel) that will name the container but utilize the NSManagedObjectModel referenced.
    
    // let viewContext = DataController().container.viewContext // the var viewContext, is the context associated with the created container in the DataController class.
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    } // init works with DataController(), so that when DataController() is called, the persistent stores of the container inside of DataController load. DataController().(something) access that inside of that class, the initializer makes sure the data inside DataController is loaded and accessible, otherwise an error is thrown.
    
    func saveData() {
        do {
            try DataController().container.viewContext.save()
            print("Game data saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    } // save() saves the context of the container so that the persistent store is updated with new data, whether that be an updated or deleted information.
}
