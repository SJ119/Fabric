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
 /*
        func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
            if newCount == 0 {
                //self.tableView.reloadData()
            }
            self.tabBarController?.tabBar.items?[0].image = UIImage(named: "achievements")
            newCount = 0
        }
    */
        // MARK: - Table view data source
        
        /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
 */
/*
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return achievements.count
        }
*/
  /*
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
   */
        
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

