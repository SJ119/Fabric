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
 

    
    /*
     @IBOutlet weak var dueDatePicker: UIDatePicker!
     This value is either passed by `TaskTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new task.
     */
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        
        // Set up views if editing an existing Task.
        if let task = task {
            navigationItem.title = task.name
            nameTextField.text = task.name
            descTextField.text = task.desc
            dueDatePicker.date = task.dueDate
            
            dueDatePicker.minimumDate = NSDate()
            
        }
        
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
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    //This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let desc = descTextField.text ?? ""
            let dueDate = dueDatePicker.date ?? NSDate()
            let status = "Current"
            // set the task to be passed to TaskTableViewController after the unwind segue.
            task = Task(name: name, desc: desc, dueDate: dueDate, status: status)
        }
        
    }
    

}

