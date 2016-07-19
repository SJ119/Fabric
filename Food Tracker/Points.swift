//
//  Task.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class Points: NSObject, NSCoding {
    //MARK: Properties
    
    var points:Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURLPoints = DocumentsDirectory.URLByAppendingPathComponent("points")
    
    //MARK: Types
    struct PropertyKey {
        static let points = "points"
    }
    
    //MARK: Initialization
    
    init?(points: Int) {
        // Initialize stored properties.
        self.points = points
        super.init()
    }
    //MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(points, forKey: PropertyKey.points)
        
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let p = aDecoder.decodeObjectForKey(PropertyKey.points) as! Int
        //Must call designated initializer.
        self.init(points: p)
        
    }
}
