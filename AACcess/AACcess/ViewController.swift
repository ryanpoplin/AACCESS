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
                
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                
            mainView.addSubview(theTableView)
                
        }
        
        if let moc = self.managedObjectContext {
            
            // created but not saved???
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