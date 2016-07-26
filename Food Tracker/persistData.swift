//
//  persistData.swift
//  Fabric
//
//  Created by Shen Jin on 2016-07-18.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class PersistData {

    //MARK: NSCoding
    class func saveTasks(tasks:[Task], url:NSURL) {
        let url_str = url.path!
        print("Saving \(tasks.count) task(s) to \(String(url_str.characters.suffix(5))) datastore")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: url_str)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }

    class func loadTasks(url:NSURL) -> [Task]? {
        let url_str = url.path!
        print("Loading tasks from \(String(url_str.characters.suffix(5)))")
        /*let data = JsonManager.getInstance().fetch("kevin", url: "http://lit-plains-99831.herokuapp.com/get_task")
        print("data")
        print(data)
        let tasks = JsonManager.getInstance().convertToTasks(data)
        if tasks.count > 0 {
            print(tasks[0].toJson())
        }*/
        return NSKeyedUnarchiver.unarchiveObjectWithFile(url_str) as? [Task]
    }

    class func syncServer(tvc: UITabBarController, tblvc: UITableViewController, username:String?, fetchAfterSync : Bool = false) {
        
        TaskUtils.fetch_task_group(tvc)
        
        let mainGroup = TaskUtils.getMainTaskGroup()
        if mainGroup != nil && username != nil {
            print("sync with server")
            let delobj = JsonObject()
            delobj.setPermanentEntry("name", obj: JsonString(str : username!))
            JsonManager.getInstance().send( delobj , url: "http://lit-plains-99831.herokuapp.com/delete_user_tasks", type: "DELETE") {_ in
                print("Delete data finished")
                let sendobj = JsonObject()
                sendobj.setPermanentEntry("name", obj: JsonString(str : username!))
                
                let alltasks = mainGroup!.getAllTasks()
                
                sendobj.setPermanentEntry("tasks", obj: JsonObjectList(objs: alltasks))
                
                JsonManager.getInstance().send( sendobj , url: "http://lit-plains-99831.herokuapp.com/create_tasks", type: "POST") { _ in
                    print("Post data finished")
                    if fetchAfterSync {
                        fetchFromServer(tvc,tblvc: tblvc, username: username)
                    }
                }
            }
        }
    }

    class func fetchFromServer(tvc: UITabBarController, tblvc: UITableViewController, username: String?) {
        TaskUtils.fetch_task_group(tvc)
        
        JsonManager.getInstance().fetch(username!, url: "http://lit-plains-99831.herokuapp.com/get_task") {
            data in
            print("Fetch data finished")
            let tasks = JsonManager.getInstance().convertToTasksWithID(data)
            TaskUtils.saveServerTasks(tasks)
            TaskUtils.passTasksToViews(tvc)
            TaskUtils.fetch_task_group(tvc)
            dispatch_async(dispatch_get_main_queue()) {
                tblvc.tableView.reloadData()
            }
        }
    }
}