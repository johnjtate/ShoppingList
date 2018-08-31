//
//  Item+Convenience.swift
//  ShoppingList
//
//  Created by John Tate on 8/31/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    @discardableResult
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context){
        
        self.init(context: context)
        self.name = name
    }
}
