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
}

func loadTasks(url:NSURL) -> [Task]? {
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