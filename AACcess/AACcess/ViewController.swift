//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/3/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData

// type in: command+shift+o...
// debug, view debugging, capture view hierarchy...

class ViewController: UIViewController, UITableViewDataSource, UIAlertViewDelegate {

    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if let managedObjectContext = appDelegate.managedObjectContext {
        
            return managedObjectContext
        
        } else {
        
            return nil
        
        }
    
        }()
    
    // a variable to hold an instance of UITableView class...
    // ?
    var tableView: UITableView?
    
    // interesting...
    override func viewDidAppear(animated: Bool) {
       
        // ...
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        println(managedObjectContext!)
        
        // UIView before the UITableView...
        // the view controller comes with a stock UIView?
        let mainView = self.view
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: mainView.bounds, style: .Plain)
        
        if let moc = self.managedObjectContext {
            
            //            Category.createInManagedObjectContext(moc, title: "Quick Phrases")
            //            Category.createInManagedObjectContext(moc, title: "Feelings")
            //            Category.createInManagedObjectContext(moc, title: "Food")
            
            func presentCategoryInfo() {
                
                let fetchRequest = NSFetchRequest(entityName: "Category")
                
                if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Category] {
                    
                    // ...
                    for var i = 0; i < fetchResults.count; i++ {
                        
                        println(fetchResults[i].title)
                        
                    }
                    
                }
                
            }
            
            // unwrapping the optional value?
            if let theTableView = tableView {
                
                // what i want to render in each cell of this UITableView...
                theTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
                
                // tableView will get its data through this class, ViewController...
                theTableView.dataSource = self
                
                // ...
                theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                
                mainView.addSubview(theTableView)
                
            }
            
            presentCategoryInfo()
            
        }
        
    }
    
    // ...
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    // ...
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    // ...
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
        
    }
    
    // ...
    override func prefersStatusBarHidden() -> Bool {
        
        return true
        
    }
    
    // ...
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    
    }

}