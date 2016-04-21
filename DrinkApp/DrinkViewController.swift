//
//  DrinkViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var libraryToolbarButton: UIBarButtonItem!
    @IBOutlet weak var cameraToolbarButton: UIBarButtonItem!
    
    
    let cashDelegate = CashTextFieldDelegate()
    
    /*
    This value is either passed by DrinkTableViewController in prepareForSegue(_:sender:)
    or constructed as part of adding a new drink
    */
    var drink: Drink?
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        priceTextField.delegate = cashDelegate
        descriptionTextField.delegate = self
        
        // Set up views if editing an existing Drink.
        if let drink = drink {
            navigationItem.title = drink.name
            nameTextField.text = drink.name
            photoImageView.image = drink.photo
            priceTextField.text = drink.price
            descriptionTextField.text = drink.description
        }
        
        // Enable the Save button only if the text field has a Valid Drink name.
        checkValidDrinkName()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraToolbarButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    // MARK: IBActions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddDrinkMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDrinkMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func selectImage(sender: UIBarButtonItem) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        if sender == libraryToolbarButton {
            imagePickerController.sourceType = .PhotoLibrary
        }
        else if sender == cameraToolbarButton {
            imagePickerController.sourceType = .Camera
        }
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let drink = drink {
                drink.name = nameTextField.text ?? ""
                drink.description = descriptionTextField.text ?? ""
                drink.price = priceTextField.text ?? ""
                drink.photo = photoImageView.image
            }
            else {
                let name = nameTextField.text ?? ""
                let description = descriptionTextField.text ?? ""
                let price = priceTextField.text ?? ""
                let photo = photoImageView.image
                
                // Set the drink to be passed to DrinkTableViewController after the unwind segue.
                drink = Drink(name: name, price: price, photo: photo, description: description)
            }
        }
    }
    
    // MARK: Helper Methods
    
    func checkValidDrinkName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }

}

// MARK: - UIImagePickerControllerDelegate
extension DrinkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension DrinkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDrinkName()
        
        if textField == nameTextField {
            navigationItem.title = textField.text
        }
        
    }
    
}

