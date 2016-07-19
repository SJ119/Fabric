//
//  JsonManager.swift
//  Fabric
//
//  Created by admin on 7/19/16.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

/* How to write to Json
 * Usage1 : let the class to write inherit JsonObject class
 *          then override the updateJsonEntries function
 *          example shown in Task.swift
 * Usage2 : create a JsonObject
 *          manually set entries
 *
 * Write to json file : JsonManager.getInstance().writeJson
 *
 * How to read from Json
 * Read from json file : JsonManager.getInstance().readJson
 * Convert to Task : JsonManager.getInstance().convertToTasks
 * Convert to Contact : TBD
 * Conver to Achievements : TBD
 */

import UIKit

class JsonWritableObject : NSObject {
    //override this function in subclass when necessary
    func toJson()->String {
        return ""
    }
    
    //no "protected" keyword in swift
    func isString()->Bool {
        return false
    }
}

class JsonString : JsonWritableObject {
    var str = ""
    
    init(str : String) {
        self.str = str
    }
    
    override func toJson()->String {
        return str;
    }
    
    override func isString()->Bool {
        return true
    }
}

//classes should inherit this class and override setJsonEntry method
class JsonObject : JsonWritableObject {
    var objs = [(String, JsonWritableObject)]()
    
    func setEntry(name: String, obj : JsonWritableObject) {
        objs.append((name, obj));
    }
    
    //override this function
    func updateJsonEntries() {
    }
    
    func clear() {
        objs.removeAll()
    }
    
    override func toJson()->String {
        updateJsonEntries()
        var str = ""
        var count = 0
        str = str + "{"
        for obj in objs {
            count = count + 1
            str = str + "\"" + obj.0 + "\":"
            if obj.1.isString() {
                str = str + "\""
            }
            str = str +  obj.1.toJson()
            if obj.1.isString() {
                str = str + "\""
            }
            if count != objs.count {
                str = str + ","
            }
        }
        
        str = str + "}"
        return str;
    }
}

class JsonObjectList : JsonWritableObject {
    var objs = [JsonObject]()
    
    init(objs : [JsonObject]) {
        
        self.objs = objs
    }
    
    override func toJson()->String {
        var str = ""
        var count = 0
        str = str + "["
        for obj in objs {
            count = count + 1
            str = str + obj.toJson()
            if count != objs.count {
                str = str + ","
            }
        }
        
        str = str + "]"
        return str;
    }
}

class JsonManager {
    private static let m = JsonManager()
    
    private init() {
    }
    
    static func getInstance() ->JsonManager {
        return m
    }
    
    func writeJson(obj : JsonWritableObject, filename : String) -> Bool {
        //generate Json String
        let string = obj.toJson()
        //print(JsonManager.writeJson)
        //print(string)
        
        //write to file
        let file = filename
        let text = string
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            //writing
            do {
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {
                return false
            }
            
        }
        
        return true
    }
    
    func readJson(filename : String) -> NSData {
        
        let file = filename
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(file)
            
            
            //reading
            do {
                let data = try NSData(contentsOfURL: path, options: [])
                //print("JsonManager.readJson")
                //let text = NSString(data: data, encoding: NSUTF8StringEncoding)!
                //print(text)
                return data
            }
            catch {
                return NSData()
            }
        }
        
        return NSData()
    }
    
    func convertToTasks(data : NSData) -> [Task]{
        var tasks = [Task]()
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            let taskEntries = jsonDict["tasks"]
            
            //print("converToTasks")
            //print(taskEntries![0]!["due_date"]!)
            //print(taskEntries!.dynamicType)
            let entries = taskEntries! as! [NSDictionary]
            //print (entries.count)
            for entry in entries {
                //print(entry.dynamicType)
                //print(entry["name"])
                let date = entry["due_date"]! as! String
                let nsdate = DateUtils.dateFromString(date, format: "yyyy:MM:dd:HH:mm")
                let name = String(entry["name"]!)
                let desc = String(entry["description"]!)
                let status = String(entry["status"]!)
                let task = Task(name: name, desc: desc, dueDate: nsdate, status: status)!
                //print(task)
                tasks.append(task)
            }
        } catch {
            
            
        }
        //print(tasks)
        return tasks
    }
}
