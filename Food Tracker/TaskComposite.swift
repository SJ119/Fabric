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
    var leaf = true
    
    init?(name: String, desc:String, leaf:Bool) {
        super.init(name: name, desc: desc, dueDate: nil, status: "Group", visible: false)
        self.leaf = leaf
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.desc) as? String
        
        //Must call designated initializer.
        self.init(name:name, desc: desc!, leaf: true)
    }
    
    func add(task: Task) {
        tasks += [task]
    }
    
    func isLeaf() -> Bool {
        return leaf
    }
    
    func getAllTasks() -> [Task] {
        var alltasks = [Task]()
        for task in tasks {
            let gtask = task as? TaskGroup
            if gtask != nil {
                if gtask!.isLeaf() {
                    alltasks = alltasks + gtask!.tasks
                } else {
                    alltasks = alltasks + gtask!.getAllTasks()
                }
            } else {
                alltasks.append(task)
            }

        }
        return alltasks
    }
    
    func getChild(index: Int) -> TaskGroup? {
        let child = tasks[index] as? TaskGroup
        return child
    }
}

class TaskUtils {
    static var main_task_group: TaskGroup?
    static var serverTasks = [Int: Task]()
    
    class func getMainTaskGroup() -> TaskGroup?{
        return main_task_group
    }
    
    /*class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }*/

    class func fetch_task_group(tvc: UITabBarController) {
        let cached_task_group = TaskGroup(name: "MainGroup", desc: "Group of 3 sub TaskGroups", leaf: false)!
        let delayed_task_group = TaskGroup(name: "DelayedGroup", desc: "Delayed TaskGroup", leaf: true)!
        let current_task_group = TaskGroup(name: "CurrentGroup", desc: "Current TaskGroups", leaf: true)!
        let completed_task_group = TaskGroup(name: "CompletedGroup", desc: "Completed TaskGroups", leaf: true)!
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

    /*class func get_from_server(tvc: UITabBarController, username: String) {
        print("GETTING FROM SERVER: ")
        let url = "http://lit-plains-99831.herokuapp.com/get_task?name=\(username)"
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

    }*/

    class func passTasksToViews(tvc: UITabBarController) {
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
        
        print("pass tasks")
        print(delayedTasks.count)
        print(currentTasks.count)
        print(completedTasks.count)
        
        //saveTasks(taskViewController!.tasks, url: Task.ArchiveURL)
        //saveTasks(doneViewController!.tasks, url: Task.ArchiveURLDone)
        //saveTasks(delayViewController!.tasks, url: Task.ArchiveURLDelay)
    }

    /*class func convertJSONTasks(jsonTasks: [AnyObject]) {
        for task in jsonTasks {
            let task_name = task["task_name"] as! String
            let task_status = task["status"] as! String
            let task_description = task["description"] as! String
            let task_due_date_string = task["due_date"] as! String
            let id = task["id"] as! Int
            
            let task_due_date = DateUtils.dateFromString(task_due_date_string, format: "yyyy:MM:dd:HH:mm")
            let t = Task(name: task_name, desc: task_description, dueDate: task_due_date, status: task_status, visible: true)

            serverTasks[id] = t
        }
    }*/
    
    class func saveServerTasks(tasks : [Int : Task]) {
        serverTasks = tasks
        for idTask in serverTasks {
            if idTask.1.status == "sent" {
                idTask.1.status = "Current"
                let sendobj = JsonObject()
                sendobj.setPermanentEntry("id", obj: JsonString (str : String(idTask.0)))
                JsonManager.getInstance().send(sendobj, url: "http://lit-plains-99831.herokuapp.com/delete_task", type: "DELETE")
                print("saveServerTask: sent task detected, delete on server")
                let sendobj2 = idTask.1
                sendobj2.setPermanentEntry("user", obj: JsonString(str : User.getGloablInstance().userid))
                JsonManager.getInstance().send( sendobj , url: "http://lit-plains-99831.herokuapp.com/new_task", type: "POST")
            }
        }
    }
    
    class func retriveTaskContacts(task : Task) -> [String] {
        var names = [String]()
        var name = ""
        var count = 0
        
        if task.status.characters.count > 8 {
            if task.status[task.status.startIndex..<task.status.startIndex.advancedBy(8)] != "ToBeSent" {
                return names
            }
        } else {
            return names
        }
        
        for char in task.status.characters {
            if char == "," {
                names.append(name)
                name = ""
            } else if count < 8 {
                
                count = count + 1
            } else if char != " " {
                name = name + String(char)
            }
        }
        return names
        
    }

    /*class func add_to_server(username: String) {
        print("ADDING TO SERVER: ")
        if main_task_group != nil {
            for sub_group in main_task_group!.tasks {
                let tg = sub_group as! TaskGroup
                print("Looping on: \(tg.name)")
                for task in tg.tasks {
                    print("Adding task: \(task.name)")
                    let url = "http://lit-plains-99831.herokuapp.com/new_task?name=\(task.name)&description=\(task.desc)&status=\(task.status)&user=\(username)"
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
    }*/
}

