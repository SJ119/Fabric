//
//  TaskViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-02-11.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var sendToButton: UIButton!
    @IBOutlet weak var listContactsForSending: UILabel!
    
    @IBAction func SelectingDate(sender: AnyObject) {
        let currDate = NSDate()
        self.dueDatePicker.minimumDate = currDate
        
    }
    /*
     @IBOutlet weak var dueDatePicker: UIDatePicker!
     This value is either passed by `TaskTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new task.
     */
    var task: Task?
    var origin: String?
    var origin_idx: Int?
    var recievingContacts: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // Set up views if editing an existing Task.
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            descTextField.text = task.desc
            dueDatePicker.date = task.dueDate!
            publicSwitch.on = task.visible
            listContactsForSending.text = ""
            
            dueDatePicker.minimumDate = NSDate()
            
        }
        
        listContactsForSending.text = ""
        //Enable the Save button only if the text field has a valid Task name.
        checkValidTaskName()
    }
    

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidTaskName()
        navigationItem.title = textField.text
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidTaskName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    //MARK:Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        //let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        let isPresentingInAddTaskMode = presentingViewController is UITabBarController
        if isPresentingInAddTaskMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func unwindToTask(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? recipientTableViewController {
            for cell in sourceViewController.tableView.visibleCells as! [recipientTableCell] {
                if cell.sending.on {
                    if (cell.nameLabel.text != nil) {
                        let user = cell.nameLabel.text
                        recievingContacts += String(user!) + ", "
                    }
                }
            }
        }
        listContactsForSending.text = recievingContacts
        
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let desc = descTextField.text ?? ""
            let dueDate = dueDatePicker.date ?? NSDate()
            let status = "Current"
            let visible = publicSwitch.on ?? true
            // set the task to be passed to TaskTableViewController after the unwind segue.
            task = Task(name: name, desc: desc, dueDate: dueDate, status: status, visible: visible)
            
            if origin != nil {
                navigationController!.popViewControllerAnimated(false)
            } else {
                navigationController!.popViewControllerAnimated(true)
            }
        }
    }
    

}

