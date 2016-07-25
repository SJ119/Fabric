//
//  JsonManager.swift
//  Fabric
//
//  Created by yc on 7/19/16.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

/* How to write to Json
 * Usage1 : let the class to write inherit JsonObject class
 *          then override the updateJsonEntries function
 * Usage2 : create a JsonObject
 *          manually set entries
 *
 * Write to json file : JsonManager.getInstance().writeJson
 * Send to server : JsonManager.getInstance().send
 *
 * How to read from Json
 * Read from json file : JsonManager.getInstance().readJson
 *
 * Convert to Task : JsonManager.getInstance().convertToTasks
 * Convert to Contact : TBD
 * Convert to Achievements : TBD
 *
 *
 * Example 1: create Json using inheritance
 * {"name":"","description":"","due_date":"","status":"","user":""}
 * 
 * How to create
 * (1) In Task.swift, inherit JsonObject class
 *     class Task: JsonObject, NSCoding
 * (2) Override updateJsonEntries function by adding whatever entry needed
 *     Each time toJson() is called the entries will be automatically updated to newest value
 *     Sample Code:
 *     override func updateJsonEntries() {
 *         self.clear()
 *         let date = DateUtils.stringFromDate(self.dueDate, format: "yyyy:MM:dd:HH:mm")
 *         self.setEntry("name", obj: JsonString(str: self.name))
 *         self.setEntry("description", obj: JsonString(str: self.desc))
 *         self.setEntry("due_date", obj: JsonString(str: date))
 *         self.setEntry("status", obj: JsonString(str: self.status))
 *         self.setEntry("user", obj: JsonString(str: ""))
 *     }
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example 2:
 * {"status":"","tasks":[{"name":"","description":"","due_date":"","status":"","user":""}]}
 * 
 * How to create
 * (1) Do steps in example 1 so that Task is a JsonObject
 * (2) Create a new Json Object and add entry manually
 * (3) Use JsonObjectList for list entry
 * Code:
 *     let block = JsonObject()
 *     block.setEntry("status", obj: JsonString(str : "Success!"))
 *     block.setEntry("tasks", obj: JsonObjectList(objs: tasks))
 *     JsonManager.getInstance().send(block, url : "")
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example 3:
 * Send to server
 *     JsonManager.getInstance().send(block, url : "http://lit-plains-99831.herokuapp.com/new_task")
 *
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
    
    init(str : String?) {
        if str == nil {
            self.str = ""
        } else {
            self.str = str!
        }
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
    var objs2 = [(String, JsonWritableObject)]()
    
    func setEntry(name: String, obj : JsonWritableObject) {
        objs.append((name, obj));
    }
    
    func setPermanentEntry(name: String, obj : JsonWritableObject) {
        objs2.append((name, obj));
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
            if count != objs.count || objs2.count != 0 {
                str = str + ","
            }
        }
        count = 0
        for obj in objs2 {
            count = count + 1
            str = str + "\"" + obj.0 + "\":"
            if obj.1.isString() {
                str = str + "\""
            }
            str = str +  obj.1.toJson()
            if obj.1.isString() {
                str = str + "\""
            }
            if count != objs2.count {
                str = str + ","
            }
        }
        
        str = str + "}"
        return str;
    }
}

class JsonObjectList : JsonWritableObject {
    var objlist = [JsonObject]()
    
    init(objs : [JsonObject]) {
        
        self.objlist = objs
    }
    
    override func toJson()->String {
        var str = ""
        var count = 0
        str = str + "["
        for obj in objlist {
            count = count + 1
            str = str + obj.toJson()
            if count != objlist.count {
                str = str + ","
            }
        }
        
        str = str + "]"
        return str;
    }
}

class JsonManager {
    
    var lastSentSuccess = true
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
            
            let entries = taskEntries! as! [NSDictionary]
            //print (entries.count)
            for entry in entries {
                let date = entry["due_date"]! as! String
                let nsdate = DateUtils.dateFromString(date, format: "yyyy:MM:dd:HH:mm")
                let name = String(entry["name"]!)
                let desc = String(entry["description"]!)
                let status = String(entry["status"]!)
                //let visible = String(entry["visible"]!) == "True"
                let task = Task(name: name, desc: desc, dueDate: nsdate, status: status, visible: true)!
                //print(task)
                tasks.append(task)
            }
        } catch {
            
            
        }
        //print(tasks)
        return tasks
    }
    
    func convertToTasksWithID(data : NSData) -> [Int : Task] {
        var idtasks = [Int : Task]()
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            let taskEntries = jsonDict["tasks"]
            var optTasks = taskEntries
            if (taskEntries != nil) {
                optTasks = taskEntries! as? [NSDictionary]
            }
            if optTasks == nil {
                print("no tasks in data")
            } else {
                let tasks = optTasks!
                //print (entries.count)
                for task in tasks as! [AnyObject] {
                    let task_name = task["task_name"] as! String
                    let task_status = task["status"] as! String
                    let task_description = task["description"] as! String
                    let task_due_date_string = task["due_date"] as! String
                    let id = task["id"] as! Int
                    
                    let task_due_date = DateUtils.dateFromString(task_due_date_string, format: "yyyy:MM:dd:HH:mm")
                    let t = Task(name: task_name, desc: task_description, dueDate: task_due_date, status: task_status, visible: true)
                    
                    idtasks[id] = t
                }
            }
        } catch {
            
        }
        return idtasks
    }
    
    func send(obj : JsonWritableObject, url : String, type : String) {
        //don't send delete request if last sent failed
        if type == "DELETE" && !self.lastSentSuccess {
            print("last send failed, don't send delete")
            return
        }
        
        // create the request & response
        let request = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
    
        // create some JSON data and configure the request
        let jsonString = obj.toJson()
        print("Generate Json")
        print(jsonString)
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // send the request
        //try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            do {
                if data == nil {
                    print("Network Connection Died, Cannot Send Data")
                    return
                }
                let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves) as? NSDictionary
                
                if let parseJSON = myJSON {
                    let status = parseJSON["status"] as? String
                    if(status! == "OK")
                    {
                        print("Status OK")
                    }
                    else
                    {
                        print(parseJSON["message"])
                    }
                }
                self.lastSentSuccess = true
                
            } catch {
                self.lastSentSuccess = false
                print("error catched send")
                print(error)
            }
            
            // look at the response
            if let httpResponse = response as? NSHTTPURLResponse {
                print("HTTP response: \(httpResponse.statusCode)")
            } else {
                print("No HTTP response")
            }
            
        }
        task.resume()
        print("Json Sent")
    }
    
    func fetch(username : String, url : String, completionHandler: (data: NSData) -> ()) {
        
        let url2 = url + "?name=" + username
        print(url2)
        let request = NSMutableURLRequest(URL: NSURL(string: url2)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)

        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let session = NSURLSession.sharedSession()
        print("fetch")
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in

            print("enter callback fetch")
            //let myJSON = try NSJSONSerialization.JSONObjectWithData(data!, options:.MutableLeaves)
            
            //print(myJSON)
            if data == nil {
                print("Network Connection Died, Cannot Send Data")
                return
            }
            completionHandler(data: data!);
            
            
            // look at the response
            if let httpResponse = response as? NSHTTPURLResponse {
                print("HTTP response: \(httpResponse.statusCode)")
            } else {
                print("No HTTP response")
            }
            
        }
        task.resume()
    }
}

//date conversion utility
class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)!
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
}