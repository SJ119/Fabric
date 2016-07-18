//
//  AchievementsViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-07-04.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class AchievementsViewController: UITableViewController, UINavigationControllerDelegate {
    
        var achievements = [String]()

        //achievements
        //Complete Task
        var achieveComplete : [String] = ["Completed a task", "Completed 3 tasks", "Completed 10 tasks"]
        //Delay Task
        var achieveDelay : [String] = ["Delayed a task", "Delayed 3 tasks", "Delayed 10 tasks"]
        //Add Contact
        var achieveContact : [String] = ["Added a contact", "Added 3 contacts", "Added 5 contacts"]
    
        //helper numbers
        var threshold : [Int] = [1,3,10]
        var threshold2 : [Int] = [1,3,5]
        var iComplete = 0
        var iDelay = 0
        var iContact = 0
    
        //tracking numbers
        var complete = 0
        var delay = 0
        var contact = 0
    
        var newCount = 0
        
        func addTask(task: Task) {
            var newAchieve = false
            if task.status == "Complete" && iComplete <= 2 {
                complete = complete + 1
                if complete == threshold[iComplete] {
                    achievements.insert(achieveComplete[iComplete], atIndex:  0)
                    iComplete = iComplete + 1
                    newAchieve = true
                }
            }
            else if task.status == "Delayed" && iDelay <= 2{
                delay = delay + 1
                if delay == threshold[iDelay] {
                    achievements.insert(achieveDelay[iDelay], atIndex:  0)
                    iDelay = iDelay + 1
                    newAchieve = true
                }
            }
            else if task.status == "Contact" && iContact <= 2{
                contact = contact + 1
                if contact == threshold2[iContact] {
                    achievements.insert(achieveContact[iContact], atIndex:  0)
                    iContact = iContact + 1
                    newAchieve = true
                }
            }
            self.tableView.reloadData()
            if newAchieve {
                //need to make a different image
                self.tabBarController?.tabBar.items?[0].image = UIImage(named: "achievementsnotify")
                newCount = newCount + 1
            }
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController!.delegate = self
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
            if newCount == 0 {
                self.tableView.reloadData()
            }
            self.tabBarController?.tabBar.items?[0].image = UIImage(named: "achievements")
            newCount = 0
        }
    
        // MARK: - Table view data source
        
        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return achievements.count
        }
        
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell: AchievementTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Achievement") as! AchievementTableViewCell
            let achievement = achievements[indexPath.row]
            if let label = cell.nameLabel{
                label.text = achievement
                if indexPath.row < newCount {
                    label.text = label.text! + " (New)"
                }
            }

            // Configure the cell...
            
            return cell
        }
        
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         if editingStyle == .Delete {
         // Delete the row from the data source
         tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
         } else if editingStyle == .Insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        /*
         // Override to support rearranging the table view.
         override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}

