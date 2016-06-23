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
    
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testMealInitialization() {
        // Success case.
        let potentialItem = Meal(name: "Newest meal", desc: "", dueDate: NSDate(), status: "current")
        XCTAssertNotNil(potentialItem)
        
        //Failure cases.
        let noName = Meal(name: "", desc: "", dueDate: NSDate(), status: "current")
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
    // Test to confirm contact initializer works
    func testContactInitialization() {
        //Success case.
        let potentialContact = Contact(name: "Samantha", photo: nil)
        XCTAssertNotNil(potentialContact)
        
        //Failure cases.
        let noName = Contact(name: "", photo: nil)
        XCTAssertNil(noName, "Empty name is invalid")
    }
    
}
