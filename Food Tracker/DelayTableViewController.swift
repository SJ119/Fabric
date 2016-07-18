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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

}
