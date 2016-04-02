//
//  DrinkViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let cashDelegate = CashTextFieldDelegate()
    
    /*
    This value is either passed by DrinkTableViewController in prepareForSegue(_:sender:)
    or constructed as part of adding a new drink
    */
    var drink: Drink?
    
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
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        if textField == nameTextField {
            nameTextField.resignFirstResponder()
            descriptionTextField.becomeFirstResponder()
        }
        else if textField == descriptionTextField {
            descriptionTextField.resignFirstResponder()
            priceTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidDrinkName()
        if textField == nameTextField {
            navigationItem.title = textField.text
        }
    }
    
    func checkValidDrinkName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        selectedImage.resize(0.5)
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
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
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let drink = drink {
                print("Drink was edited")
                drink.name = nameTextField.text ?? ""
                drink.description = descriptionTextField.text ?? ""
                drink.price = priceTextField.text ?? ""
                drink.photo = photoImageView.image
            }
            else {
                print("Drink was created")
                let name = nameTextField.text ?? ""
                let description = descriptionTextField.text ?? ""
                let price = priceTextField.text ?? ""
                let photo = photoImageView.image
                
                // Set the drink to be passed to DrinkTableViewController after the unwind segue.
                drink = Drink(name: name, photo: photo, price: price, description: description)
            }
        }
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

