//
//  TaskTableViewController.swift
//  Fabric
//
//  Created by Samantha Lauer on 2016-06-20.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TaskTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var tasks = [Task]()

    override func viewDidLoad() {
        print("loading task table view")
        super.viewDidLoad()
        _ = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(TaskTableViewController.reloadCurrent(_:)), userInfo: nil, repeats: true)
        //self.view.backgroundColor = UIColor.lightGrayColor()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        // Load any saved tasks, otherwise load sample data.
        if let savedTasks = loadTasks() {
            // saved Tasks is an array of tasks if any are past their deadline move it to delay list
            let currentDate = NSDate()
            
            for item in savedTasks {
                if (item.dueDate.compare(currentDate) == NSComparisonResult.OrderedAscending) {
                    //due date has passed, move to delayed
                    item.status = "Delayed"
                    print("delay item: " + item.name)
                    self.presentDestinationViewControllerDelay(item)
                    
                } else {
                    tasks += [item]
                }
            }
            //tasks += savedTasks
        }
    }
    
    
        
    func presentDestinationViewController(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[3] as? DoneTableViewController
        viewController?.addTask(task)
    }
    
    func presentDestinationViewControllerDelay(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[1] as? DelayTableViewController
        viewController?.addTask(task)
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> MGSwipeTableCell {
        //Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TaskTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        
        // Fetches the appropriate task for the data source layout.
        let task = tasks[indexPath.row]

        cell.nameLabel.text = task.name
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"Complete.png"), backgroundColor: UIColor.greenColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            let task = self.tasks.removeAtIndex(indexPath.row)
            task.status = "Complete"
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
            self.presentDestinationViewController(task)
            return true
        })]
        cell.leftSwipeSettings.transition = MGSwipeTransition.Border
        cell.leftExpansion = MGSwipeExpansionSettings()
        cell.leftExpansion.buttonIndex = 0
        cell.leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named:"Delay.png"), backgroundColor: UIColor.yellowColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            self.tasks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
            task.status = "Delayed"
            self.presentDestinationViewControllerDelay(task)
            return true
        })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Border
        
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tasks.removeAtIndex(indexPath.row)
            saveTasks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    func reloadCurrent(timer: NSTimer) {
        if let savedTasks = loadTasks() {
            // saved Tasks is an array of tasks if any are past their deadline move it to delay list
            let currentDate = NSDate()
            
            //var i = 0
            for item in savedTasks {
                if (item.dueDate.compare(currentDate) == NSComparisonResult.OrderedAscending) {
                    //due date has passed, move to delayed
                    item.status = "Delayed"
                    //tasks.removeAtIndex(i)
                    self.tableView.reloadData()
                    self.presentDestinationViewControllerDelay(item)
                    
                    //item.status = "Delayed"
                    print("delay item: " + item.name)
                    //self.presentDestinationViewControllerDelay(item)
                    
                } else {
                    tasks += [item]
                   // i += 1
                }
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let taskDetailViewController = segue.destinationViewController as! TaskViewController
            // Get the cell that generated this segue.
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            }
        } else if segue.identifier == "AddItem" {
            print("Adding new task.")
        }
    }
    
    @IBAction func addToComplete(sender: UIStoryboardSegue) {
        performSegueWithIdentifier("Complete", sender: self)
    }
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TaskViewController, task = sourceViewController.task {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new task.
                let newIndexPath = NSIndexPath(forRow: tasks.count, inSection: 0)
                tasks.append(task)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                
            }
            // Save the tasks.
            saveTasks()
        }
    }
    
    //MARK: NSCoding
    func saveTasks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() -> [Task]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Task.ArchiveURL.path!) as? [Task]
    }

}
