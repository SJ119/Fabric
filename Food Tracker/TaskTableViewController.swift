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
        super.viewDidLoad()
        print("Loading TaskTableView")
        
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(TaskTableViewController.reloadCurrent(_:)), userInfo: nil, repeats: true)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Do an initial reload on our current list
        reloadCurrent(NSTimer())
    }
    
    
    func presentDestinationViewController(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
        viewController?.addTask(task)
    }
    
    func presentDestinationViewControllerDelay(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
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
            self.saveTasks()
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
            self.saveTasks()
            return true
        })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Border
        cell.rightExpansion = MGSwipeExpansionSettings()
        cell.rightExpansion.buttonIndex = 0
        cell.rightExpansion.fillOnTrigger = true
        
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

    func reloadCurrent(timer: NSTimer) {
        if let savedTasks = loadTasks() {
            if savedTasks.count == 0 {
                // nothing to process
                return
            }
            
            // saved Tasks is an array of tasks if any are past their deadline move it to delay list
            let currentDate = NSDate()
            
            var delayIdx = [Int]()
            for (i, item) in savedTasks.enumerate() {
                if (item.dueDate.compare(currentDate) == NSComparisonResult.OrderedAscending) {
                    print("Task \(i) is delayed, recorded \(i) as need to remove")
                    delayIdx.append(i);
                } else {
                    print("Task \(i) is not delayed")
                }
            }
            
            delayIdx = delayIdx.reverse()
            print("Tasks needed to be removed in reverse order are \(delayIdx)")
            print("Tasks length: \(self.tasks.count)")
            let taskLength = self.tasks.count
            for idx in delayIdx {
                if (idx < taskLength) {
                    print("idx: " + String(idx))
                    //due date has passed, move to delayed
                    let task = self.tasks[idx]
                    self.tasks.removeAtIndex(idx)
                    let indexPath = NSIndexPath(forRow: idx, inSection: 0)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.reloadData()
                    task.status = "Delayed"
                    self.presentDestinationViewControllerDelay(task)
                }
            }
            
            saveTasks()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" || segue.identifier == "EditDetail" {
            let taskDetailViewController = segue.destinationViewController as! TaskViewController
            // Get the cell that generated this segue.
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
            }
        } else if segue.identifier == "AddItem" {
            print("Preparing to add new task.")
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
                print("Adding new task \(task.name).")
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
