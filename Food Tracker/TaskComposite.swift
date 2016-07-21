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

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}

var main_task_group: TaskGroup?
var serverTasks = [Int: Task]()

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

func get_from_server(tvc: UITabBarController) {
    print("GETTING FROM SERVER: ")
    let url = "http://lit-plains-99831.herokuapp.com/get_task?name=shen"
    print ("URL: \(url)")
    let escapedAddress = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    
    let request = NSMutableURLRequest(URL: NSURL(string: escapedAddress!)!)
    request.HTTPMethod = "GET"
    
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
        let resString = responseString as! String
        
        let jsonTasks = convertStringToDictionary(resString)!["tasks"]! as! [AnyObject]
        convertJSONTasks(jsonTasks)
        passTasksToViews(tvc)
        
    }
    task.resume()

}

func passTasksToViews(tvc: UITabBarController) {
    var delayedTasks = [Task]()
    var currentTasks = [Task]()
    var completedTasks = [Task]()
    for (_, task) in serverTasks {
        if task.status == "Complete" {
            completedTasks += [task]
        } else if task.status == "Delayed" {
            delayedTasks += [task]
        } else {
            currentTasks += [task]
        }
    }
    
    let delayViewController = tvc.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
    let taskViewController = tvc.childViewControllers[2].childViewControllers[0] as? TaskTableViewController
    let doneViewController = tvc.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
    
    delayViewController!.tasks = delayedTasks
    taskViewController!.tasks = currentTasks
    doneViewController!.tasks = completedTasks
    
    saveTasks(taskViewController!.tasks, url: Task.ArchiveURL)
    saveTasks(doneViewController!.tasks, url: Task.ArchiveURLDone)
    saveTasks(delayViewController!.tasks, url: Task.ArchiveURLDelay)
}

func convertJSONTasks(jsonTasks: [AnyObject]) {
    for task in jsonTasks {
        let task_name = task["task_name"] as! String
        let task_status = task["status"] as! String
        let task_description = task["description"] as! String
        let task_due_date_string = task["due_date"] as! String
        let id = task["id"] as! Int
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm"
        let task_due_date = dateFormatter.dateFromString(task_due_date_string)
        
        let t = Task(name: task_name, desc: task_description, dueDate: task_due_date, status: task_status, visible: true)

        serverTasks[id] = t
    }
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

