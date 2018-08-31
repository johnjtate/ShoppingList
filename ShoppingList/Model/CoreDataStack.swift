//
//  CoreDataStack.swift
//  ShoppingList
//
//  Created by John Tate on 8/31/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack{
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load from the Core Data Stack \(error) \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    static func saveToPersistentStore(){
        do{
            try CoreDataStack.context.save()
        } catch {
            print("There was an error in \(#function) : \(error) \(error.localizedDescription)")
        }
    }
    
    static func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }
}
