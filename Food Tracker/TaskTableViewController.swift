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
        self.tableView.reloadData()
    }
    
    
        
    func presentDestinationViewController(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
        viewController?.addTask(task)
    }
    
    func presentDestinationViewControllerDelay(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
        viewController?.addTask(task)
    }
    
    func loadDestinationViewController() {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
        viewController?.loadTasks()
    }
    
    func loadDestinationViewControllerDelay() {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
        viewController?.loadTasks()
    }
    
    
    
    func presentDestinationViewControllerAchievement(task: Task) {
        let viewController = UIApplication.sharedApplication().windows[0].rootViewController?.childViewControllers[0].childViewControllers[0] as? AchievementsViewController
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
            self.presentDestinationViewControllerAchievement(task)
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
            self.presentDestinationViewControllerAchievement(task)
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
            
            var i = 0
            var delayIdx = [Int]()
            for item in savedTasks {
                if (item.dueDate.compare(currentDate) == NSComparisonResult.OrderedAscending) {
                    print("I am delayed, removing from tasks and adding to delayed")
                    delayIdx.append(i);
                } else {
                    print("I am not delayed, adding to tasks")
                    tasks += [item]
                }
                i += 1
            }
            
            delayIdx = delayIdx.reverse()
            print("Task length: " + String(self.tasks.count))
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
    
    //MARK: JsonManager.swift
    func saveTasks() {
        //var isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Task.ArchiveURL.path!)
        
        //save to json
        let block = JsonObject()
        block.setEntry("status", obj: JsonString(str : "Success!"))
        block.setEntry("tasks", obj: JsonObjectList(objs: tasks))
        let isSuccessfulSave = JsonManager.getInstance().writeJson(block, filename: "out.json")
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() -> [Task]? {
        let data = JsonManager.getInstance().readJson("out.json")
        let tasklist = JsonManager.getInstance().convertToTasks(data)
        return tasklist
        //return NSKeyedUnarchiver.unarchiveObjectWithFile(Task.ArchiveURL.path!) as? [Task]
    }

}
