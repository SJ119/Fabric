//
//  TaskComposite.swift
//  Fabric
//
//  Created by Shen Jin on 2016-07-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class TaskGroup: Task {
    var tasks = [Task]()
    
    init?(name: String, desc:String) {
        super.init(name: name, desc: desc, dueDate: nil, status: "Group")
    }
    
    func add(task: Task) {
        tasks += [task]
    }
    
}


//var cached_task_group = TaskGroup("")
//
//var fetch_task_group() {
//    
//}