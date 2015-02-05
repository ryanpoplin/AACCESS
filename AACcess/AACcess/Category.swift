//
//  Categories.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/5/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    // allow the variable to work with the CoreData Framework...
    @NSManaged var title: String

    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String) -> Category {
        
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: moc) as Category
        
        newCategory.title = title
        
        return newCategory
        
    }
    
}