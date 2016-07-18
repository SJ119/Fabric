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
    
    //MARK: Properties
    @IBOutlet weak var ContactPhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var contact: Contact?
    
    // MARK: Action
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        //nameTextField.delegate = self
        
        // Set up views if editing an existing Contact.
        if let contact = contact {
            navigationItem.title = contact.name
            ContactPhoto.image = contact.photo
            nickNameLabel.text = contact.nickName
            emailLabel.text = contact.email
            //nameTextField.text = task.name
           // descTextField.text = task.desc
           // dueDatePicker.date = task.dueDate
            
        }
        

        
        //Enable the Save button only if the text field has a valid Task name.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Edit" {
            let contactDetailViewController = segue.destinationViewController as! ContactViewController
            // Get the contact that generated this segue.
            /*if let selectedContactCell = sender as? ContactTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            }*/
            contactDetailViewController.contact = contact
        }
    }
    
}
