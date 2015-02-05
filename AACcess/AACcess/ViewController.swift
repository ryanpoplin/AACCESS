//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/3/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

import UIKit

// type in: command+shift+o...
// debug, view debugging, capture view hierarchy...

class ViewController: UIViewController, UITableViewDataSource {

    // a variable to hold an instance of UITableView class...
    // ?
    var tableView: UITableView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // UIView before the UITableView...
        let mainView = self.view
        
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: mainView.bounds, style: .Plain)
        
        // unwrapping the optional value?
        if let theTableView = tableView {
            
            // what i want to render in each cell of this UITableView...
            theTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier")
            
            // ...
            theTableView.dataSource = self
            
            // ...
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            
            mainView.addSubview(theTableView)
        
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "Section \(indexPath.section), " + "Cell \(indexPath.row)"
        
        return cell
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    
    }

}