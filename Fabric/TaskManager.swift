//
//  TaskManager.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-15.
//  Copyright © 2016 KYSS. All rights reserved.
//

import UIKit

var taskManager: TaskManager = TaskManager()

struct task {
    var title = "Task 1"
    var description = "Testing"
    var date = "YYYY/MM/DD"
    // type = event or reminder
    var type = "Event"
}

class TaskManager: NSObject {
    var loTasks = [task]()
    
    func insertTask(title: String, description: String, date: String, type: String) {
        loTasks.append(task(title: title, description: description, date: date, type: type))
        
    }

}
