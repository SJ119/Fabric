//
//  ContactInfoViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-06.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController, UINavigationControllerDelegate {
    // When page is called it fills this value with the contact that was clicked on
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        //nameTextField.delegate = self
        
        // Set up views if editing an existing Contact.
        if let contact = contact {
            navigationItem.title = contact.name
            //nameTextField.text = task.name
           // descTextField.text = task.desc
           // dueDatePicker.date = task.dueDate
            
        }
        
        //Enable the Save button only if the text field has a valid Task name.
    }

    
}
