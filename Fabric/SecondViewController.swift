//
//  SecondViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-15.
//  Copyright © 2016 KYSS. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskDesc: UITextField!
    @IBOutlet var taskDuration: UITextField!
    @IBOutlet var taskDate: UIDatePicker!
    @IBOutlet var taskType: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Events
    @IBAction func fillingTaskTitle(sender: UITextField) {
        taskTitle.layer.borderColor = UIColor.grayColor().CGColor
        taskTitle.layer.borderWidth = 0
        taskTitle.layer.cornerRadius = 5
        
    }
    
    @IBAction func addButtonClicked(sender: UIButton){
        var type = "Event"
        if taskType.on {
            type = "Reminder"
        } else {
            //Do Nothing
        }
        
        if (taskTitle.hasText()) {
            taskManager.insertTask(taskTitle.text!, description: taskDesc.text!, date: taskDate.date, duration: taskDuration.text!, type: type)
            self.view.endEditing(true)
            taskTitle.text = ""
            taskDesc.text = ""
            taskDuration.text = "0"
            self.tabBarController!.selectedIndex = 0
        }
        else {
            taskTitle.layer.borderColor = UIColor.redColor().CGColor
            taskTitle.layer.borderWidth = 1
            taskTitle.layer.cornerRadius = 5
        }
        
        
        
        
        //don't need line below (optional)
        
        
    }
    
    //Touch Screen Functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

