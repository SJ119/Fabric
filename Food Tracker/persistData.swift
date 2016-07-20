//
//  persistData.swift
//  Fabric
//
//  Created by Shen Jin on 2016-07-18.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

//MARK: NSCoding
func saveTasks(tasks:[Task], url:NSURL) {
    let url_str = url.path!
    print("Saving \(tasks.count) task(s) to \(String(url_str.characters.suffix(5))) datastore")
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: url_str)
    if !isSuccessfulSave {
        print("Failed to save tasks...")
    }
    
    //send Json as well
    let block = JsonObject()
    block.setEntry("status", obj: JsonString(str : "Success!"))
    block.setEntry("tasks", obj: JsonObjectList(objs: tasks))
    
    //JsonManager.getInstance().send(block, url : "http://lit-plains-99831.herokuapp.com/new_task")
}

func loadTasks(url:NSURL) -> [Task]? {
    let url_str = url.path!
    print("Loading tasks from \(String(url_str.characters.suffix(5)))")
    return NSKeyedUnarchiver.unarchiveObjectWithFile(url_str) as? [Task]
}