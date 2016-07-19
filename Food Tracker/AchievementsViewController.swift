//
//  AchievementsViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-04.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var currPoints = 50
    func addTask(task: Task) {
        if (task.status == "Complete") {
            print("completeing a task")
            currPoints += 10
        } else if (task.status == "Delayed") {
            print("delayed a task")
            currPoints -= 15
        }
        
        if pointsLabel != nil  {
            pointsLabel.text = String(currPoints) + "pts"
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController!.delegate = self
            pointsLabel.text = String(currPoints) + "pts"
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

        
}

