//
//  Drink.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/16/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class Drink {
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var price: String
    var description: String
    var base64String: String?
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, price: String, description: String) {
        // Initialize stored properties.
        self.name = name
        self.price = price
        self.photo = photo
        self.description = description
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
    
    func encodeImage() {
        let imageData = UIImagePNGRepresentation(photo!)
        base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    func decodeImage() {
        let decodedData = NSData(base64EncodedString: base64String!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedimage = UIImage(data: decodedData!)
    }
}