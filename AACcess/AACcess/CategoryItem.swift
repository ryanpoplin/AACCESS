//
//  CategoryItem.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/6/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import Foundation
import CoreData

class CategoryItem: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var category: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, category: String) -> CategoryItem {
        
        let newCategoryItem = NSEntityDescription.insertNewObjectForEntityForName("CategoryItem", inManagedObjectContext: moc) as CategoryItem
                
        newCategoryItem.title = title
        newCategoryItem.category = category
        
        return newCategoryItem
        
    }
    
}