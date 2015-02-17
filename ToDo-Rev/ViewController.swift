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
    var taskName = String()
    
    override func viewDidLoad() {
        


        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        self.view.backgroundColor = UIColor.blueColor()
        taskModel.getTaskList()
        println("number of tasks = \(numOfTask)")
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //     update(num)
        numOfTask = taskModel.getNumberOfTasks()
        return numOfTask
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 1
        
        var date = cell.viewWithTag(1) as UILabel
        var name = cell.viewWithTag(2) as UILabel
        var detail = cell.viewWithTag(3) as UILabel
        detail.sizeToFit()
        detail.numberOfLines = 0
        detail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        var tasks = taskModel.sortTasks()
        name.text = tasks[indexPath.row].name
        date.text = tasks[indexPath.row].displayDate
        detail.text = tasks[indexPath.row].detail
        println("row:\(indexPath.row) priority:\(tasks[indexPath.row].priority)")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        println(tasks[indexPath.row].completion)
        if tasks[indexPath.row].completion == true {
            cell.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.4)
        }
        return cell
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 44
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 44
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func update(num: Int) {
        taskTable.frame = CGRectMake(0, 64, self.view.frame.width, 83 * CGFloat(num))
    }
    override func viewDidLayoutSubviews() {
        taskTable.frame = CGRectMake(0, 64, self.view.frame.width, 83 * CGFloat(numOfTask))
    }
    override func viewDidAppear(animated: Bool) {
        taskTable.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            taskModel.deleteTask(indexPath.row)
            numOfTask--
            update(numOfTask)
            taskTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        taskModel.complete(indexPath.row)
        println("tap on \(indexPath.row)")
        
        taskTable.reloadData()
    }
    
    
}

