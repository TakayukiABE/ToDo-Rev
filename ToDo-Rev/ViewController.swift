//
//  ViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/15.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var taskTable: UITableView!
    
    var numOfTask = 0
    var taskModel = TaskTableModel()
    var tasks = [TaskObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        self.view.backgroundColor = UIColor.blueColor()
        taskModel.getTaskList()
        tasks = taskModel.sortTasks()
        numOfTask = taskModel.getNumberOfTasks()
        println("number of tasks = \(numOfTask)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //     update(num)
        return numOfTask
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var date = cell.viewWithTag(1) as UILabel
        var name = cell.viewWithTag(2) as UILabel
        
        name.text = tasks[indexPath.row].name
        
        

        date.text = "a"
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
//    func update(num: Int) {
//        taskTable.frame = CGRectMake(0, 64, self.view.frame.width, 44 * CGFloat(num))
//    }
    override func viewDidLayoutSubviews() {
        taskTable.frame = CGRectMake(0, 64, self.view.frame.width, 44 * CGFloat(numOfTask))
    }
    
}

