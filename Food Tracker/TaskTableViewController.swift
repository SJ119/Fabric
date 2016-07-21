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
    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loading TaskTableView")
        
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(TaskTableViewController.reloadCurrent(_:)), userInfo: nil, repeats: true)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Restore our saved tasks
        if let savedTasks = loadTasks(Task.ArchiveURL) {
            tasks = savedTasks
        }
        
        // Do an initial reload on our current list
        reloadCurrent(NSTimer())
    }
    
    func getViewControllerDone() -> DoneTableViewController? {
        let viewController = self.parentViewController?.parentViewController?.childViewControllers[3].childViewControllers[0] as? DoneTableViewController
        return viewController
    }
    
    
    func getViewControllerDelay() -> DelayTableViewController? {
        let viewController = self.parentViewController?.parentViewController?.childViewControllers[1].childViewControllers[0] as? DelayTableViewController
        return viewController
    }
    
    func presentDestinationViewControllerAchievement(task: Task) {
        let viewController = self.parentViewController?.parentViewController?.childViewControllers[0].childViewControllers[0] as? AchievementsViewController
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
        let date = task.dueDate
        let dateFormater = NSDateFormatter()
        dateFormater.dateStyle = .MediumStyle
        dateFormater.timeStyle = .ShortStyle
        
        let datestring = dateFormater.stringFromDate(date!)
        cell.DateLabel.text = datestring
        if (task.status == "Urgent") {
            cell.DateLabel.textColor = UIColor.redColor()
        }
        
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"Complete.png"), backgroundColor: UIColor.greenColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            let task = self.tasks.removeAtIndex(indexPath.row)
            task.status = "Complete"
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()

            self.presentDestinationViewControllerAchievement(task)
            let vcd = self.getViewControllerDone()
            vcd?.addTask(task)
            saveTasks(self.tasks, url: Task.ArchiveURL)

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
            
            self.presentDestinationViewControllerAchievement(task)
            let vcd = self.getViewControllerDelay()
            vcd?.addTask(task)
            saveTasks(self.tasks, url: Task.ArchiveURL)

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
            saveTasks(tasks, url: Task.ArchiveURL)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }

    func reloadCurrent(timer: NSTimer) {
        if var savedTasks = loadTasks(Task.ArchiveURL) {
            if savedTasks.count == 0 {
                // nothing to process
                print("nothing to process")
                return
            }
            
            // saved Tasks is an array of tasks if any are past their deadline move it to delay list
            let currentDate = NSDate()
            
            var delayIdx = [Int]()
            for (i, item) in savedTasks.enumerate() {
                if (item.dueDate!.compare(currentDate) == NSComparisonResult.OrderedAscending) {
                    print("Task \(i) is delayed, recorded \(i) as need to remove")
                    delayIdx.append(i);
                } else {
                    print("Task \(i) is not delayed")
                    let dateDifference = daysBetweenDates(currentDate, endDate: item.dueDate!)
                    if (dateDifference == 0) {
                        self.tasks[i].status = "Urgent"
                    }
                }
                
            }
            tableView.reloadData()
            
            delayIdx = delayIdx.reverse()
            print("Tasks needed to be removed in reverse order are \(delayIdx)")
            print("Tasks length: \(self.tasks.count)")
            let taskLength = self.tasks.count
            for idx in delayIdx {
                if (idx < taskLength) {
                    print("idx: " + String(idx))
                    //due date has passed, move to delayed
                    let task = savedTasks[idx]
                    self.tasks.removeAtIndex(idx)
                    let indexPath = NSIndexPath(forRow: idx, inSection: 0)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    tableView.reloadData()
                    task.status = "Delayed"

                    self.presentDestinationViewControllerAchievement(task)
                    let vcd = self.getViewControllerDelay()
                    vcd?.addTask(task)
                }
            }
            
            saveTasks(self.tasks, url: Task.ArchiveURL)
            
            let tvc = self.parentViewController?.parentViewController as! UITabBarController
            fetch_task_group(tvc)
            
            if username != nil {
                //            add_to_server(username)
                get_from_server(tvc, username: username!)
            }

            tableView.reloadData()
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
            print("Preparing to add new task.")
        }
    }
    
    @IBAction func addToComplete(sender: UIStoryboardSegue) {
        performSegueWithIdentifier("Complete", sender: self)
    }
    
    @IBAction func unwindToTaskList(sender: UIStoryboardSegue) {
        print("Call to unwindToTaskList")
        if let sourceViewController = sender.sourceViewController as? TaskViewController, task = sourceViewController.task {
            print("Call from TaskViewController")
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print("Updating existing path")
                // Update an existing task.
                tasks[selectedIndexPath.row] = task
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new task.
                print("Adding new task \(task.name).")
                let newIndexPath = NSIndexPath(forRow: tasks.count, inSection: 0)
                task.status = "Current"
                tasks.append(task)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                
                JsonManager.getInstance().send(task, url: "http://lit-plains-99831.herokuapp.com/new_task")
                
                // check origin of TaskViewController
                if sourceViewController.origin != nil {
                    let vcd = getViewControllerDelay()
                    vcd?.removeTask(sourceViewController.origin_idx!)
                }
            }
            // Save the tasks.
            saveTasks(tasks, url: Task.ArchiveURL)
        }
    }
    

}
