//
//  Contact.swift
//  Food Tracker
//
//  Created by Samantha Lauer on 2016-06-23.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class Contact {
    
    //MARK: Properties
    
    var name:String
    var photo:UIImage?
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?) {
        
        //Initialize stored properties.
        self.name = name
        self.photo = photo
        
        if name.isEmpty {
            return nil
        }
        
    }
    
    
    
}
