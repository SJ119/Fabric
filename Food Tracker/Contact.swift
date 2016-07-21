//
//  Contact.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-23.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class Contact:NSObject{
    
    //MARK: Properties
    
    var name:String
    var nickName:String
    var email:String
    var photo:UIImage?
    
    //MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let nickNameKey = "nickName"
        static let emailKey = "email"
        static let photoKey = "photo"
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("contacts")
    
    // MARK: Initialization
    init?(name: String, nickName: String, email: String, photo: UIImage?) {
        
        //Initialize stored properties.
        self.name = name
        self.photo = photo
        self.nickName = nickName
        self.email = email
        
        super.init()
    
        if name.isEmpty {
            return nil
        }
        
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(nickName, forKey: PropertyKey.nickNameKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let nickName = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as! UIImage
        
        self.init(name:name, nickName: nickName, email: email, photo: photo)
    }
    
    
}
