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
    
    //MARK: Action
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
//        if let savedContacts = loadContacts() {
//            contacts += savedContacts
//        }
    }
    
    //MARK: NSCoding
    /*func saveContacts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contacts, toFile: Contact.ArchiveURL.path!)
        if !isSuccessfulSave {
            print ("Failed to save meals...")
        }
    }*/
    
//    func loadContacts() -> [Contact]? {
//        return NSKeyedUnarchiver.unarchiveObjectWithFile(Contact.ArchiveURL.path!) as? [Contact]
//    }

}
