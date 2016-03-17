//
//  DrinkTableViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/16/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class DrinkTableViewController: UITableViewController {
    
    // MARK: Properties
    var drinks = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load sample data.
        loadSampleDrinks()
    }
    
    func loadSampleDrinks() {
        let photo1 = UIImage(named: "drink1")!
        let drink1 = Drink(name: "Drink 1", photo: photo1, price: "3")!
        
        let photo2 = UIImage(named: "drink2")!
        let drink2 = Drink(name: "Drink 2", photo: photo2, price: "4")!
        
        let photo3 = UIImage(named: "drink3")!
        let drink3 = Drink(name: "Drink 3", photo: photo3, price: "2")!
        
        drinks += [drink1, drink2, drink3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // Fetches the appropriate drink for the data source layout.
        let drink = drinks[indexPath.row]
        
        cell.nameLabel.text = drink.name
        cell.photoImageView.image = drink.photo
        cell.priceLabel.text = drink.price

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            drinks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
            print("Adding new drink.")
        }
    }
    
    @IBAction func unwindToDrinkList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? DrinkViewController, drink = sourceViewController.drink {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing drink.
                drinks[selectedIndexPath.row] = drink
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new drink.
                let newIndexPath = NSIndexPath(forRow: drinks.count, inSection: 0)
                drinks.append(drink)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }

}
