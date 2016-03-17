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
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?, price: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.price = price
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}