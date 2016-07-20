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
        super.init(name: name, desc: desc, dueDate: nil, status: "Group", visible: false)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.desc) as? String
        
        //Must call designated initializer.
        self.init(name:name, desc: desc!)
    }
    
    func add(task: Task) {
        tasks += [task]
    }
    
}

var main_task_group: TaskGroup?

func fetch_task_group(tvc: UITabBarController) {
    let cached_task_group = TaskGroup(name: "MainGroup", desc: "Group of 3 sub TaskGroups")!
    let delayed_task_group = TaskGroup(name: "DelayedGroup", desc: "Delayed TaskGroup")!
    let current_task_group = TaskGroup(name: "CurrentGroup", desc: "Current TaskGroups")!
    let completed_task_group = TaskGroup(name: "CompletedGroup", desc: "Completed TaskGroups")!
    let delayViewController = tvc.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
    let taskViewController = tvc.childViewControllers[2].childViewControllers[0] as? TaskTableViewController
    let doneViewController = tvc.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
    
    delayed_task_group.tasks += delayViewController!.tasks
    current_task_group.tasks += taskViewController!.tasks
    completed_task_group.tasks += doneViewController!.tasks
    
    cached_task_group.add(delayed_task_group)
    cached_task_group.add(current_task_group)
    cached_task_group.add(completed_task_group)
    
    main_task_group = cached_task_group
}


func add_to_server() {
    print("ADDING TO SERVER: ")
    if main_task_group != nil {
        for sub_group in main_task_group!.tasks {
            let tg = sub_group as! TaskGroup
            print("Looping on: \(tg.name)")
            for task in tg.tasks {
                print("Adding task: \(task.name)")
                let url = "http://lit-plains-99831.herokuapp.com/new_task?name=\(task.name)&description=\(task.desc)&status=\(task.status)&user=shen"
                print ("URL: \(url)")
                let escapedAddress = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

                let request = NSMutableURLRequest(URL: NSURL(string: escapedAddress!)!)
                request.HTTPMethod = "POST"
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    
                    let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                }
                task.resume()
            }
        }
    }
}

