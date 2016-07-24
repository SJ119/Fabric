//
//  AchievementsViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-04.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBAction func logout(sender: UIButton) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout"
        {
            let detailVC = segue.destinationViewController as! ShowSplashScreen
            detailVC.loggedout = true
            print("MAYBEEEEE")
        }
    }
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var points = Points(points:50)
    var username: String?
    
    var diff = 0
    func addTask(task: Task) {
        print("ACHIEVEMENT UPDATING POINTS")
        if (task.status == "Complete") {
            print("completeing a task")
            diff += 10
        } else if (task.status == "Delayed") {
            print("delayed a task")
            diff -= 15
        }
        
        if pointsLabel != nil  {
            points!.points += diff
            pointsLabel.text = String(points!.points) + "pts"
            
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(points!, toFile: Points.ArchiveURLPoints.path!)
            if !isSuccessfulSave {
                print("Failed to save tasks...")
            } else {
                diff = 0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.delegate = self
        
        if self.username != nil && self.username != usernameLabel.text {
            usernameLabel.text = self.username
        }
        
        if let points = NSKeyedUnarchiver.unarchiveObjectWithFile(Points.ArchiveURLPoints.path!) as? Points {
            self.points = points
        }
        
        self.points!.points += diff
        pointsLabel.text = String(points!.points) + "pts"
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(points!, toFile: Points.ArchiveURLPoints.path!)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        } else {
            diff = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

