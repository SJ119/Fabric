//
//  User.swift
//  Fabric
//
//  Created by Parth Pancholi on 2016-07-21.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding{
    var status:Bool
    var userid:String
    var password:String
    
    private static var user = User(userid: "", password: "", status: false)
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("userInfo")
    
    
    struct PropertyKey {
        static let statusKey = "status"
        static let useridKey = "userid"
        static let passwordKey = "password"
    }
    
    class func getGloablInstance() -> User{
        return self.user!
    }
    
    class func setGlobalInstance(userid: String, password: String, status: Bool) {
        self.user!.userid = userid
        self.user!.password = password
        self.user!.status = status
    }
//    init(coder aDecoder: NSCoder)
//    {
//        
//    }
    
    init?(userid: String, password: String, status: Bool)
    {
        // Initialize stored properties.
        self.status = status
        self.userid = userid
        self.password = password
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if userid.isEmpty || password.isEmpty {
            return nil
        }
        
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(status, forKey: PropertyKey.statusKey)
        aCoder.encodeObject(userid, forKey: PropertyKey.useridKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let userid = aDecoder.decodeObjectForKey(PropertyKey.useridKey) as! String
        let password = aDecoder.decodeObjectForKey(PropertyKey.passwordKey) as! String
        let status = aDecoder.decodeObjectForKey(PropertyKey.statusKey) as! Bool
        
        self.init(userid: userid, password: password, status: status)
        
    }
}
















