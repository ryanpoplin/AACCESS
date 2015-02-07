//
//  DrilledDownCategoryViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/6/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData

class DrilledDownCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            return managedObjectContext
            
        } else {
            
            return nil
            
        }
        
        }()
    
    var tableView: UITableView?
    
    var categoryItems = [CategoryItem]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(managedObjectContext!)
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryItemCell")
        
        var viewFrame = self.view.frame
        
        viewFrame.size.height -= 100
        
        tableView!.frame = viewFrame
        
        self.view.addSubview(tableView!)
        
        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 100, UIScreen.mainScreen().bounds.size.width, 100))
        addButton.setTitle("Add Category Item", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        addButton.addTarget(self, action: "addNewCategoryItem", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        tableView!.dataSource = self
        tableView!.delegate = self
        
        fetchCategory()
        
    }
    
    func fetchCategory() {
        
        let fetchRequest = NSFetchRequest(entityName: "CategoryItem")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
//        let predicate = NSPredicate(format: "category == %@", "Beer")
//        
//        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CategoryItem] {
            
            categoryItems = fetchResults
            
        }
        
    }
    
    func addNewCategoryItem() {
                
        var titlePrompt = UIAlertController(title: "Enter Category Item Title", message: "Enter Text", preferredStyle: .Alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "Title"
        }
        
        titlePrompt.addAction(UIAlertAction(title: "Ok",
            style: .Default, handler: {
                (action) -> Void in
                if let textField = titleTextField {
                    if let categoryTitle = ViewController().categoryTitleProperty {
                        self.saveNewCategoryItem(textField.text, category: categoryTitle)
                    }
                }
        }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
        
    }
    
    func saveNewCategoryItem(title: String, category: String) {
        
        var newCategoryItem = CategoryItem.createInManagedObjectContext(self.managedObjectContext!, title: title, category: category)
        
        self.fetchCategory()
        
        if let newCategoryIndex = find(categoryItems, newCategoryItem) {
            
            let newCategoryItemIndexPath = NSIndexPath(forItem: newCategoryIndex, inSection: 0)
            
            tableView!.insertRowsAtIndexPaths([newCategoryItemIndexPath], withRowAnimation: .Automatic)
            
            save()
            
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let logItemToDelete = categoryItems[indexPath.row]
            
            managedObjectContext?.deleteObject(logItemToDelete)
            
            self.fetchCategory()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            save()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryItemCell") as UITableViewCell
        
        let categoryItem = categoryItems[indexPath.row]
        
        println(categoryItem.title)
        println(categoryItem.category)
        
        cell.textLabel?.text = categoryItem.title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("Pressed...")
        
    }
    
    func save() {
        
        var error: NSError? = nil
        if managedObjectContext!.save(&error) {
            println(error?.localizedDescription)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}