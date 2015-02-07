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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategorySpecificCell")
        
        var viewFrame = self.view.frame
        
        viewFrame.size.height -= 100
        
        tableView!.frame = viewFrame
        
        self.view.addSubview(tableView!)
        
        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 100, UIScreen.mainScreen().bounds.size.width, 100))
        addButton.setTitle("Add Category Item", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        addButton.addTarget(self, action: "addNewCategory", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        tableView!.dataSource = self
        tableView!.delegate = self
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategorySpecificCell") as UITableViewCell
        
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}