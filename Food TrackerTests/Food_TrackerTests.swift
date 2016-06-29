//
//  Food_TrackerTests.swift
//  Food TrackerTests
//
//  Created by Samantha Lauer on 2016-02-11.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit
import XCTest
@testable import Food_Tracker

class Food_TrackerTests: XCTestCase {
    
    //MARK: FoodTracker Tests
    
    // Tests to confirm that the Task initializer returns when no name or a negative rating is provided.
    func testTaskInitialization() {
        // Success case.
        let potentialItem = Task(name: "Newest task", desc: "", dueDate: NSDate(), status: "current")
        XCTAssertNotNil(potentialItem)
        
        //Failure cases.
        let noName = Task(name: "", desc: "", dueDate: NSDate(), status: "current")
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
    // Test to confirm contact initializer works
    func testContactInitialization() {
        //Success case.
        let potentialContact = Contact(name: "Samantha", nickName: "sam", email: "slauer@blah.com", photo: nil)
        XCTAssertNotNil(potentialContact)
        
        //Failure cases.
        let noName = Contact(name: "", nickName: "", email: "", photo: nil)
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
}
