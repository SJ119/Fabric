//
//  ContactInfoViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-06.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController, UINavigationControllerDelegate,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // When page is called it fills this value with the contact that was clicked on
    
    var tasks = [Task]()
    
    //MARK: Properties
    @IBOutlet weak var ContactPhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var contact: Contact?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "taskcell")
        tableView.delegate = self
        tableView.dataSource = self
        tasks += [Task(name: "a", desc: "b", dueDate: nil, status: "Current", visible: true)!]
        self.tableView.reloadData()
        
        // Handle the text field's user input through delegate callbacks
        //nameTextField.delegate = self
        
        
        
//        self.addGroup.delegate = self

        
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
    
    // MARK: Action
    
    @IBAction func refreshTableView(sender: AnyObject) {
        
        print("test")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("taskcell", forIndexPath: indexPath) as! TaskTableViewCell
        
        cell.nameLabel.text = tasks[indexPath.row].name
        let date = tasks[indexPath.row].dueDate
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        dateFormater.timeStyle = .ShortStyle
        
        let datestring = dateFormater.stringFromDate(date!)
        cell.DateLabel.text = datestring

        return cell
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
