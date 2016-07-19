//
//  DelayTableViewController.swift
//  Fabric
//
//  Created by Shen Jin on 2016-06-27.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class DelayTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var tasks = [Task]()
    
    func addTask(task: Task) {
        print("Call to addTask in DelayTable for task \(task)")
        tasks.append(task)
        self.tableView.reloadData()
        
        // Save delayed tasks
        saveTasks(tasks, url: Task.ArchiveURLDelay)
    }
    
    func removeTask(task_idx: Int) {
        print("Remove task \(task_idx) in DelayTable)")

        self.tasks.removeAtIndex(task_idx)
        let indexPath = NSIndexPath(forRow: task_idx, inSection: 0)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load saved delayed tasks
        if let savedTasks = loadTasks(Task.ArchiveURLDelay) {
            tasks = savedTasks
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TaskTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Delay") as! TaskTableViewCell
        
        let task = tasks[indexPath.row]
        cell.nameLabel.text = task.name

        // Configure the cell...
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditDetail" {
            let taskDetailViewController = segue.destinationViewController as! TaskViewController
            // Get the cell that generated this segue.
            if let selectedTaskCell = sender as? TaskTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTaskCell)!
                let selectedTask = tasks[indexPath.row]
                taskDetailViewController.task = selectedTask
                taskDetailViewController.origin = "Delay"
                taskDetailViewController.origin_idx = indexPath.row
            }
        }
    }

}
