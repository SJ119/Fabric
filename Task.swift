//
//  Task.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class Task: JsonObject, NSCoding {
    //MARK: Properties
    
    var name:String
    var desc:String
    var dueDate:NSDate?
    var status:String
    var visible:Bool
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("tasks")
    static let ArchiveURLDelay = DocumentsDirectory.URLByAppendingPathComponent("delay")
    static let ArchiveURLDone = DocumentsDirectory.URLByAppendingPathComponent("done")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let desc = "description"
        static let dueDate = "dueDate"
        static let status = "status"
        static let visible = "visible"
    }
    
    //MARK: Initialization
    
    init?(name: String, desc:String, dueDate:NSDate?, status:String, visible:Bool) {
        // Initialize stored properties.
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.status = status
        self.visible = visible
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.name)
        aCoder.encodeObject(desc, forKey: PropertyKey.desc)
        aCoder.encodeObject(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encodeObject(status, forKey: PropertyKey.status)
        aCoder.encodeObject(visible, forKey: PropertyKey.visible)
        
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.desc) as? String
        let dueDate = aDecoder.decodeObjectForKey(PropertyKey.dueDate) as? NSDate?
        let status = aDecoder.decodeObjectForKey(PropertyKey.status) as? String
        let visible = aDecoder.decodeObjectForKey(PropertyKey.visible) as? Bool
        
        //Must call designated initializer.
        self.init(name:name,
                  desc: (desc == nil ? "" : desc!),
                  dueDate: (dueDate == nil ? NSDate() : dueDate!),
                  status: (status == nil ? "" : status!),
                  visible: (visible == nil ? false : visible!))
        
    }
    
    override func updateJsonEntries() {
        self.clear()
        
        let date = DateUtils.stringFromDate(self.dueDate!, format: "yyyy-MM-dd HH:mm:ss")
        let visible = self.visible ? "True" : "False"
        self.setEntry("name", obj: JsonString(str: self.name))
        self.setEntry("description", obj: JsonString(str: self.desc))
        self.setEntry("due_date", obj: JsonString(str: date))
        self.setEntry("status", obj: JsonString(str: self.status))
        self.setEntry("user", obj: JsonString(str: "kevin"))
        //self.setEntry("visible", obj: JsonString(str: visible))
    }
}
