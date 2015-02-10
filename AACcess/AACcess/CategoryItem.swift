//
//  CategoryItem.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/6/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import Foundation
import CoreData

// Entity name...
class CategoryItem: NSManagedObject {
    
    // Entity attributes...
    
    // @NSManaged == special permission variable to work with CoreData...
    @NSManaged var title: String
    @NSManaged var category: String
    
    // a class based method helper function for created new items in CoreData...
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, category: String) -> CategoryItem {
        
        // create a new categoryItem...
        let newCategoryItem = NSEntityDescription.insertNewObjectForEntityForName("CategoryItem", inManagedObjectContext: moc) as CategoryItem
        
        // categoryItems need a title and a associated category attributes...
        newCategoryItem.title = title
        newCategoryItem.category = category
        
        // return the goods...
        return newCategoryItem
        
    }
    
}