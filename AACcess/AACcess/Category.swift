//
//  Category.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/6/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    @NSManaged var title: String

    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String) -> Category {
        
        let newCategory = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: moc) as Category
        
        
        
        newCategory.title = title
        
        return newCategory
        
    }
    
}