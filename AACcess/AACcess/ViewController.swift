//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/3/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
        
            return managedObjectContext
        
        } else {
        
            return nil
        
        }
    
        }()
    
    var tableView: UITableView?
    
    var categoryItems = [Category]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(managedObjectContext!)
            
        let mainView = self.view
        
        tableView = UITableView(frame: mainView.bounds, style: .Plain)
            
        if let theTableView = tableView {
                
            theTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")
                
            theTableView.dataSource = self
            theTableView.delegate = self
            
            var viewFrame = self.view.frame
            
            viewFrame.size.height -= 100
            
            theTableView.frame = viewFrame
            
            mainView.addSubview(theTableView)
            
            let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 100, UIScreen.mainScreen().bounds.size.width, 100))
            addButton.setTitle("Add Category", forState: .Normal)
            addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
            addButton.addTarget(self, action: "addNewCategory", forControlEvents: .TouchUpInside)
            self.view.addSubview(addButton)
                
        }
        
        if let moc = self.managedObjectContext {
            
            Category.createInManagedObjectContext(moc, title: "Feelings")
            Category.createInManagedObjectContext(moc, title: "Food")
            Category.createInManagedObjectContext(moc, title: "Drink")
            
            fetchCategory()
        
        }
        
    }
    
    func fetchCategory() {
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Category] {
            
            categoryItems = fetchResults
            
        }
        
    }
    
    // ...
    let addCategoryAlertViewTag = 0
    func addNewCategory() {
        
        
        
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
            
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as UITableViewCell
        
        let categoryItem = categoryItems[indexPath.row]
        
        cell.textLabel?.text = categoryItem.title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let categoryItem = categoryItems[indexPath.row]
        
        println(categoryItem.title)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}