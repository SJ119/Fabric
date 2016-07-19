//
//  DoneTableViewController.swift
//  Fabric
//
//  Created by Shen Jin on 2016-06-26.
//  Copyright © 2016 Samantha Lauer. All rights reserved.
//

import UIKit

class DoneTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var tasks = [Task]()
    
    func addTask(task: Task) {
        tasks.append(task)
        self.tableView.reloadData()
        print(tasks)
        saveTasks()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        print(tasks)
        // self.tableView.registerClass(DoneTableViewCell.self, forCellReuseIdentifier: "Done")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        print(tasks)
        let cell: DoneTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Done") as! DoneTableViewCell

        let task = tasks[indexPath.row]
        if let label = cell.nameLabel{
            label.text = task.name
        }
        if let label = cell.nameLabel2{
            label.text = task.name
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
    //MARK: JsonManager.swift
    func saveTasks() {
        //save to json
        print("saveTasksDone")
        let block = JsonObject()
        block.setEntry("status", obj: JsonString(str : "Success!"))
        block.setEntry("tasks", obj: JsonObjectList(objs: tasks))
        let isSuccessfulSave = JsonManager.getInstance().writeJson(block, filename: "outDone.json")
        if !isSuccessfulSave {
            print("Failed to save tasks...")
        }
    }
    
    func loadTasks() {
        print("loadTasksDone")
        let data = JsonManager.getInstance().readJson("outDone.json")
        let tasklist = JsonManager.getInstance().convertToTasks(data)
        print(tasklist)
        tasks = Array([tasks, tasklist].flatten())
        self.tableView.reloadData()
    }
}
