//
//  Category.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/6/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import Foundation
import CoreData

// Entity name...
class Category: NSManagedObject {

    // Entity attributes...
    
    // @NSManaged == special permission variable to work with CoreData...
    @NSManaged var title: String

    // a class based method helper function for created new items in CoreData...
    // pass in what you need...
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String) -> Category {
        
        // create a new object as a Category...
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: moc) as Category
        
        // set attribute values...
        // categories only need a title...
        newCategory.title = title
        
        // return the goods...
        return newCategory
        
    }
    
}