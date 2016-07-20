//
//  recipientTableViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class recipientTableViewController: UITableViewController {
    
    //MARK: Properties
    var contacts = [Contact]()
    
    // make a pull request to server for contact list, if no connection provide error
    // OR
    // get contacts from persistent data
    
    
    
    //MARK: Action
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
