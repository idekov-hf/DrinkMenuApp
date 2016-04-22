//
//  Drink.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/16/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Firebase

class Drink {
    
    // MARK: Properties
    
    // Constants
    let drinksRef = Firebase(url: "https://drinks-app.firebaseio.com/drinks")
    
    // Variables
    var name: String
    var photo: UIImage?
    var price: String
    var description: String
    var photoURL: String?
    var photoDownloaded = false
    var ref: Firebase
    
    // MARK: Init Methods
    
    init?(name: String, price: String, photo: UIImage?, description: String) {
        
        // Initialize stored properties.
        self.name = name
        self.price = price
        self.photo = photo
        self.description = description
        
        ref = drinksRef.childByAutoId()
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
    
    init(snapshot: FDataSnapshot) {
        
        name = snapshot.value["name"] as! String
        description = snapshot.value["description"] as! String
        price = snapshot.value["price"] as! String
        photoURL = snapshot.value["photoURL"] as? String
        ref = snapshot.ref
    }
    
    // MARK: Helper Methods
    
    func toAnyObject() -> Dictionary<String, String> {
        
        return [
            "name" : name,
            "description" : description,
            "price" : price,
            "photoURL" : photoURL!
        ] 
    }

}

/*
 func encodeImage() -> String {
 let imageData = UIImagePNGRepresentation(photo!)
 return imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
 }
 
 func decodeImage(string: String) -> UIImage {
 let decodedData = NSData(base64EncodedString: string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
 return UIImage(data: decodedData!)!
 }
 */