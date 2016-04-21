//
//  DrinkTableViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/16/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Firebase

class DrinkTableViewController: UITableViewController {
    
    // MARK: Properties
    var drinks = [Drink]()
    var loggedIn: Bool = false
    let ref = Firebase(url: "https://drinks-app.firebaseio.com/drinks")
    let defaults = NSUserDefaults.standardUserDefaults()
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loggedInBool = defaults.objectForKey("loggedIn") {
            loggedIn = loggedInBool as! Bool
        }
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            // do some stuff once
            var newDrinks = [Drink]()
            for item in snapshot.children {
                let drink = Drink(snapshot: item as! FDataSnapshot)
                newDrinks.append(drink)
            }
            self.drinks = newDrinks
            self.tableView.reloadData()
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if loggedIn {
            navigationItem.leftBarButtonItem = editButtonItem()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequed using a cell identifier.
        let cellIdentifier = "DrinkTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DrinkTableViewCell
        
        cell.userInteractionEnabled = loggedIn
        
        // Fetches the appropriate drink for the data source layout.
        let drink = drinks[indexPath.row]
        
        cell.nameLabel.text = drink.name
        cell.priceLabel.text = drink.price
        cell.descriptionLabel.text = drink.description
        cell.photoImageView.image = drink.photo
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return loggedIn
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete drink data on Firebase
            let drinkRef = drinks[indexPath.row].ref
            drinkRef?.removeValue()
            // Delete the row from the data source
            drinks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let drinkDetailViewController = segue.destinationViewController as! DrinkViewController
            // Get the cell that generated this segue.
            if let selectedDrinkCell = sender as? DrinkTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedDrinkCell)!
                let selectedDrink = drinks[indexPath.row]
                drinkDetailViewController.drink = selectedDrink
            }
        }
        else if segue.identifier == "AddItem" {
//            print("Adding new drink.")
        }
    }
    
    @IBAction func unwindToDrinkList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DrinkViewController, drink = sourceViewController.drink {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing drink.
                drinks[selectedIndexPath.row] = drink
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
                
                let drinkRef = drink.ref
                drinkRef!.updateChildValues(drink.toAnyObject())
            }
            else {
                // Add a new drink.
                let newIndexPath = NSIndexPath(forRow: drinks.count, inSection: 0)
                drinks.append(drink)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                let drinkRef = drink.ref
                drinkRef!.setValue(drink.toAnyObject())
            }
        }
        else if let sourceViewController = sender.sourceViewController as? LoginViewController {
            loggedIn = sourceViewController.loggedIn
            defaults.setBool(loggedIn, forKey: "loggedIn")
        }
    }

    @IBAction func addItem(sender: UIBarButtonItem) {
        if loggedIn {
            performSegueWithIdentifier("AddItem", sender: sender)
        }
        else {
            performSegueWithIdentifier("LogIn", sender: sender)
        }
    }
}
