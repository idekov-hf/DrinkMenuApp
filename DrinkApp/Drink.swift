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
    
    let drinksRef = Firebase(url: "https://drinks-app.firebaseio.com/drinks")
    
    // MARK: Properties
    var name: String
    var photo: UIImage? {
        didSet {
            base64String = encodeImage()
        }
    }
    var price: String
    var description: String
    var base64String: String?
    var ref: Firebase?
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, price: String, description: String) {
        // Initialize stored properties.
        self.name = name
        self.price = price
        self.photo = photo
        self.description = description
        base64String = encodeImage()
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
        photo = decodeImage(snapshot.value["imageString"] as! String)
        ref = snapshot.ref
    }
    
    func encodeImage() -> String {
        let imageData = UIImagePNGRepresentation(photo!)
        return imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    func decodeImage(string: String) -> UIImage {
        let decodedData = NSData(base64EncodedString: string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        return UIImage(data: decodedData!)!
    }
    
    func toAnyObject() -> Dictionary<String, String> {
        return [
            "name" : name,
            "description" : description,
            "price" : price,
            "imageString" : base64String!
        ]
    }
}