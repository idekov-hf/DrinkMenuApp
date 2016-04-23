//
//  DrinkViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/15/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Cloudinary

class DrinkViewController: UIViewController, CLUploaderDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var libraryToolbarButton: UIBarButtonItem!
    @IBOutlet weak var cameraToolbarButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
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
        
        cameraToolbarButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        progressBar.hidden = true
        
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
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let price = priceTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the drink to be passed to DrinkTableViewController after the unwind segue.
        if let drink = drink {
            drink.name = name
            drink.description = description
            drink.price = price
            drink.photo = photo
        }
        else {
            drink = Drink(name: name, price: price, photo: photo, description: description)
        }
        
        if let photo = photo {
            uploadImage(photo)
        }
        else {
            print("uploadImage not called: photo == nil")
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
    
    // MARK: Helper Methods
    
    func checkValidDrinkName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func uploadImage(image: UIImage) {
        guard let imgData = UIImageJPEGRepresentation(image, 0.2) else {
            print("Image was not successfully converted into NSData")
            return
        }
        
        let clURL = CLCloudinary()
        clURL.config().setValue("ivdekov", forKey: "cloud_name")
        clURL.config().setValue("799619976626956", forKey: "api_key")
        clURL.config().setValue("XXmLLeGBnf3UD9GfigAifXJcG_E", forKey: "api_secret")
        
        let clUploader = CLUploader(clURL, delegate: self)
        
        progressBar.hidden = false
        
        clUploader.upload(imgData, options: ["public_id" : "\(drink!.ref.key!)"], withCompletion: { successResult, errorResult, code, context in
            
            if errorResult == nil {
                
                guard let url = successResult["url"] as? String else {
                    print("could not find value of key url in result")
                    return
                }
                
                print(url)
                
                if let drink = self.drink {
                    drink.photoURL = url
                }
                else {
                    print("drink == nil")
                }
                
                self.performSegueWithIdentifier("unwindSegue", sender: self)
                
            }
            else {
                print(errorResult)
            }
            
            }, andProgress: {bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, context in
                
                self.progressBar.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                
            }
        )
    }
    
    func resizeImage(image: UIImage, maxLength: CGFloat) -> UIImage {
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        var newWidth: CGFloat
        var newHeight: CGFloat
        var scale: CGFloat
        
        if imageWidth < maxLength && imageHeight < maxLength {
            newWidth = image.size.width
            newHeight = image.size.height
        }
        else if imageWidth > imageHeight {
            newWidth = maxLength
            scale = newWidth / imageWidth
            newHeight = imageHeight * scale
        }
        else {
            newHeight = maxLength
            scale = newHeight / imageHeight
            newWidth = imageWidth * scale
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
        var selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        print(selectedImage.size)
        
        selectedImage = resizeImage(selectedImage, maxLength: 1200)
        
        print(selectedImage.size)
        
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

