//
//  ContactTableViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-23.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    //MARK: Properties
    var contacts = [Contact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if let savedContacts = loadContacts() {
            contacts += savedContacts
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            contacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveContacts()

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "ContactTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        
        // Fetches the appropriate task for the data source layout.
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.photoImageView.image = contact.photo

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ContactDetails" {
            let contactInfoViewController = segue.destinationViewController as! ContactInfoViewController
            if let selectedContactCell = sender as? ContactTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedContactCell)!
                let selectedContact = contacts[indexPath.row]
                contactInfoViewController.contact = selectedContact
            }

        } else if segue.identifier == "AddContact" {
            print ("ADDING CONTACT")
            let uiNavigationController = segue.destinationViewController as! UINavigationController
            let contactViewController = uiNavigationController.topViewController as! ContactViewController
            contactViewController.contacts = self.contacts
        }
        
    }

    
    // Action method adds to contact list if Save button selected
    @IBAction func unwindToContactList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as?
            ContactViewController, contact = sourceViewController.contact {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                contacts[selectedIndexPath.row] = contact
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new contact
                let newIndexPath = NSIndexPath(forRow: contacts.count, inSection: 0)
                contacts.append(contact)
                
                // inserts contact at bottom (will want to alphabetize later!!
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveContacts()
        }
    }
    
    //MARK: NSCoding
    func saveContacts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contacts, toFile: Contact.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save contacts...")
        }
    }
    
    func loadContacts() -> [Contact]? {
        let contacts = NSKeyedUnarchiver.unarchiveObjectWithFile(Contact.ArchiveURL.path!) as! [Contact]
        
        let c = contacts.sort { $0.name < $1.name }
        
        return c
    }

}
