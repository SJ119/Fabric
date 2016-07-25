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
    var recipients = String()
    
    //MARK: Action
   
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        for cell in tableView.visibleCells as! [recipientTableCell] {
            if cell.sending.on {
                if (cell.nameLabel.text != nil) {
                    let user = cell.nameLabel.text
                    recipients += String(user!) + ","
                }
            }
        }
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usrname = User.getGloablInstance().userid
        contacts.append(Contact(name: usrname, nickName: "", email: "", photo: UIImage(named: "contacts"), sending: false)!)
        // Load any saved meals, otherwise load sample data.
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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "recipientTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! recipientTableCell
        
        // Fetches the appropriate task for the data source layout.
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.NicknameLabel.text = contact.nickName
        cell.photo.image = contact.photo
        cell.sending.setOn(false, animated: true)
        
        return cell
    }
    
    
    
    
    


    
    //MARK: NSCoding
    func loadContacts() -> [Contact]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Contact.ArchiveURL.path!) as? [Contact]
    }

}
