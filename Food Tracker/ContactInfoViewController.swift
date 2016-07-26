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
    var delayedTasks = [Task]()
    var completedTasks = [Task]()
    
    //MARK: Properties
    @IBOutlet weak var ContactPhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var contact: Contact?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Contact.
        if let contact = contact {
            navigationItem.title = contact.name
            ContactPhoto.image = contact.photo
            nickNameLabel.text = contact.nickName
            emailLabel.text = contact.email
            
            tableView.delegate = self
            tableView.dataSource = self
            
            //fetch the contacts tasks
            JsonManager.getInstance().fetch(contact.name, url: "http://lit-plains-99831.herokuapp.com/get_task") {
                data in
                let taskDict = JsonManager.getInstance().convertToTasksWithID(data)
                
                for key in taskDict {
                    let t = key.1
                    print("visible: \(t.visible)")
                    if !t.visible {
                        continue
                    }
                    if t.status == "Delayed" {
                        self.delayedTasks += [t]
                    } else if t.status == "Complete" {
                        self.completedTasks += [t]
                    } else {
                        self.tasks += [t]
                    }
                    
                }
                self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
            }
        }

        
        self.tableView.reloadData()
    }
    
    // MARK: Action
    
    @IBAction func refreshTableView(sender: AnyObject) {
        
        print("test")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tasks.count
        } else if section == 1 {
            return delayedTasks.count
        } else {
            return completedTasks.count
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if (section == 0){
            return "Current"
        } else if (section == 1){
            return "Delayed"
        } else {
            return "Completed"
        }
    }
    
    /*func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30))
        if (section == 0) {
            headerView.backgroundColor = UIColor.blueColor()
        } else {
            headerView.backgroundColor = UIColor.clearColor()
        }
        return headerView
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : TaskTableViewCell = tableView.dequeueReusableCellWithIdentifier("taskcell", forIndexPath: indexPath) as! TaskTableViewCell
        
        
        var task_section = tasks
        if indexPath.section == 1 {
            task_section = delayedTasks
        } else if indexPath.section == 2 {
            task_section = completedTasks
        }
        
        cell.nameLabel.text = task_section[indexPath.row].name
        let date = task_section[indexPath.row].dueDate
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        dateFormater.timeStyle = .ShortStyle
        
        if let d = date {
            let ds = dateFormater.stringFromDate(d)
            cell.DateLabel.text = ds
        } else {
            cell.DateLabel.text = "Cannot load date"
        }
        
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
