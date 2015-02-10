//
//  ViewController.swift
//  AACcess
//
//  Created by Byrdann Fox on 2/3/15.
//  Copyright (c) 2015 ExcepApps, Inc. All rights reserved.
//

// required framework imports...
import UIKit
import CoreData

// ...
public var categoryTitleProperty: String!

// add required delegation protocols...
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // lazy computed variables...
    lazy var managedObjectContext: NSManagedObjectContext? = {
        
        // utilize the existing MOC in the delegate...get access to the delegate...
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // pattern for safely unwrapping an optional value...
        if let managedObjectContext = appDelegate.managedObjectContext {
            
            // return the goods...
            return managedObjectContext
            
        } else {
            
            // something screwed up...
            return nil
            
        }
        
        }()
    
    // create a variable to hold a reference to our UITableView...
    var tableView: UITableView?
    
    // create an array that will be containing Category's...
    var categoryItems = [Category]()

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // print the unwrapped MOC to the console...
        println(managedObjectContext!)
        
        // with access to the MOC, you can create some CoreData entities to be utilized by classes in the CoreData Model Editor...
        // select the create new NSManagedObject subclass...
        // make sure the for Swift that the CoreData classes are ProjectName.ClassName...(something about the way Swift modules work...)
        
        // the navigation bar's title...
        navigationController?.navigationBar.topItem?.title = "Categories"
        
        // create an UITableView and add a few args...
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        
        // CategoryCell is the referencing cell/row...
        tableView!.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")
        
        // full frame height and width...
        var viewFrame = self.view.frame
        
        // decrease the size of the current view by 100...
        viewFrame.size.height -= 100
        
        // set this frame as the the tableView's frame...
        tableView!.frame = viewFrame
        
        // add the tableView as the a subview to the viewcontroller...
        self.view.addSubview(tableView!)
        
        // add a button with appropriate args...
        let addButton = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 100, UIScreen.mainScreen().bounds.size.width, 100))
        addButton.setTitle("Add Category", forState: .Normal)
        addButton.backgroundColor = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
        // the target will have args, and invoke the addNewCategory method...
        addButton.addTarget(self, action: "addNewCategory", forControlEvents: .TouchUpInside)
        // add this as a subview to the viewcontroller...
        self.view.addSubview(addButton)
        
        // data and delegatation functionalities will be referenced in this viewcontroller...
        tableView!.dataSource = self
        tableView!.delegate = self
        
        // call fetchCategory...
        fetchCategory()
        
    }
    
    // ...
    func fetchCategory() {
        
        // set fetch of 'Category'...
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        // a sort descriptor to make all Categories A-Z,a-z...
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // set the sortDescriptor...
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // unwrap, and fetch an array of Category items...
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Category] {
            
            // populate the array with Category's...
            categoryItems = fetchResults
            
        }
        
    }
    
    // ui for adding Categories and CategoryItems...
    func addNewCategory() {
        
        // create a UIAlertController and set it up...
        var titlePrompt = UIAlertController(title: "Enter Category Title", message: "Enter Text", preferredStyle: .Alert)
        
        // create a text field...
        var titleTextField: UITextField?
        // configure the view...
        titlePrompt.addTextFieldWithConfigurationHandler {
            (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "Title"
        }
        
        // when ok is pressed, execute saveNewCategory with the title data...
        titlePrompt.addAction(UIAlertAction(title: "Ok",
            style: .Default, handler: {
                (action) -> Void in
                if let textField = titleTextField {
                    self.saveNewCategory(textField.text)
                }
        }))
        
        // make sure the transition is animated...
        self.presentViewController(titlePrompt, animated: true, completion: nil)
        
    }
    
    func saveNewCategory(title: String) {
        
        // don't save anything if it's an empty string...
        if title != "" {
        
            // utilize the class helper method...
            var newCategory = Category.createInManagedObjectContext(self.managedObjectContext!, title: title)
        
            // update the array...
            self.fetchCategory()
        
            // find the index...
            if let newCategoryIndex = find(categoryItems, newCategory) {
            
                // create an indexPath to inject into...
                let newCategoryItemIndexPath = NSIndexPath(forItem: newCategoryIndex, inSection: 0)
            
                // insert the proper data in the proper row...
                tableView!.insertRowsAtIndexPaths([newCategoryItemIndexPath], withRowAnimation: .Automatic)
            
                // CoreData save...
                save()
            
            }
            
        }
        
    }
    
    // support the slide deletion of cells/rows...
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // if you slide the row/cell and you press the delete button...
        if editingStyle == .Delete {
            
            // grab the item to delete...
            let logItemToDelete = categoryItems[indexPath.row]
            
            // set the fetch request...
            let fetchRequest = NSFetchRequest(entityName: "CategoryItem")
            
            // predicate's will filter items based on conditions...
            let predicate = NSPredicate(format: "category == %@", logItemToDelete.title)
            
            // set the predicate...
            fetchRequest.predicate = predicate
            
            // execute the fetchRequest...
            if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [CategoryItem] {
                
                // sample array...
                var testArr = fetchResults
                
                // loop it...
                for x in testArr {
                    
                    // delete all the categoryItems associated with the category...
                    managedObjectContext?.deleteObject(x as NSManagedObject)
                    
                    // CoreData save...
                    save()
                    
                }
                
            }
            
            // delete the category...
            managedObjectContext?.deleteObject(logItemToDelete)
            
            // refresh, etc...
            self.fetchCategory()
            
            // animate the physical deletion of the the table row/cell...
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            // CoreData save...
            save()
            
        }
        
    }
    
    // return the number of rows that will show in the table view section...
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return quantity will be the amount of categoryItems...
        return categoryItems.count
        
    }
    
    // method for defining table row/cell content, etc...
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // refer to CategoryCell as the UITableViewCell...
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as UITableViewCell
        
        // get the array item's 0-X...
        let categoryItem = categoryItems[indexPath.row]
        
        // add the right direction arrows to the rows/cells...
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        // set the category text label's text to be the categoryItems's title...
        cell.textLabel?.text = categoryItem.title
        
        // return the goods...
        return cell
        
    }
    
    // ...
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get the item you're pressing on...
        let categoryItem = categoryItems[indexPath.row]
        
        // create an instance of the CategoryItems viewcontroller, etc...
        let drilledDownCategoryViewController = DrilledDownCategoryViewController()

        // set the title to be saved as an attribute to the items you'll be saving in the next viewcontroller class...
        categoryTitleProperty = categoryItem.title
        
        // push to another view...
        navigationController?.pushViewController(drilledDownCategoryViewController, animated: true)
        
    }
    
    func save() {
        
        // create an error container...
        var error: NSError? = nil
        // save the changes...
        if managedObjectContext!.save(&error) {
            // print nil || an error...
            println(error?.localizedDescription)
        }
        
    }
    
    // ...
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}