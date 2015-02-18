//
//  ViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/15.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditDelegate {
    @IBOutlet weak var taskTable: UITableView!
    
    @IBOutlet weak var todayLabel: UILabel!

    var numOfTask = 0
    var taskModel = TaskTableModel()
    var taskName = String()
    var sorting = 0
    var currentRow = 0
    override func viewDidLoad() {
        
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        self.view.backgroundColor = UIColor.blueColor()
        taskModel.getTaskList()
        println("number of tasks = \(numOfTask)")
        todayLabel.text = taskModel.getToday()
        todayLabel.backgroundColor = UIColor.whiteColor()
        taskTable.alpha = 0.9
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //     update(num)
        numOfTask = taskModel.getNumberOfTasks()
        return numOfTask
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
//        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.backgroundColor = UIColor.whiteColor()
        cell.alpha = 1
        var date = cell.viewWithTag(1) as UILabel
        var name = cell.viewWithTag(2) as UILabel
        var detail = cell.viewWithTag(3) as UILabel
        var priority = cell.viewWithTag(4) as UILabel
        detail.textColor = UIColor.blackColor()
        detail.sizeToFit()
        detail.numberOfLines = 0
        detail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        name.textColor = UIColor.blackColor()
        date.textColor = UIColor.blackColor()
        priority.textColor = UIColor.blackColor()
        
        var tasks:[TaskObject]!
        switch sorting {
            case 0: tasks = taskModel.sortTasks()
            case 1: tasks = taskModel.sortTasksPriority()
            default: println("error")
        }
        name.text = tasks[indexPath.row].name
        date.text = tasks[indexPath.row].displayDate
        detail.text = tasks[indexPath.row].detail
        println("row:\(indexPath.row) priority:\(tasks[indexPath.row].priority)")
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        println(tasks[indexPath.row].completion)
        switch tasks[indexPath.row].priority {
        case 1: priority.text = "★"
        case 2: priority.text = "★★"
        case 3: priority.text = "★★★"
        default: println("error at priority")
        }
        
        if tasks[indexPath.row].completion == true {
//            cell.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.7, alpha: 0.4)
           //         cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            name.attributedText = NSAttributedString(data: "<s>\(tasks[indexPath.row].name)&nbsp;&nbsp;&nbsp;&nbsp;</s>".dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil)
            name.font = UIFont(name: "Helvetica Neue", size: 20)
            date.attributedText = NSAttributedString(data: "<s>\(tasks[indexPath.row].displayDate)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</s>".dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil)
            date.font = UIFont(name: "System", size: 17)
            switch tasks[indexPath.row].priority {
            case 1: priority.text = "☆"
            case 2: priority.text = "☆☆"
            case 3: priority.text = "☆☆☆"
            default: println("error at priority")
            }
            detail.textColor = UIColor.grayColor()
            name.textColor = UIColor.grayColor()
            date.textColor = UIColor.grayColor()
            priority.textColor = UIColor.grayColor()
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
        if num <= 6 {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, 83 * CGFloat(num))
        }else {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, self.view.frame.height - 64)
        }
    }
    override func viewDidLayoutSubviews() {
        if numOfTask <= 6 {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, 83 * CGFloat(numOfTask))
        }else {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, self.view.frame.height - 64)
        }
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
    
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        currentRow = indexPath.row
        println("accessory")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "modifySegue" {
            var inputViewController:InputViewController = segue.destinationViewController as InputViewController
            inputViewController.edit = true
            inputViewController.editDelegate = self
        }
    }
    
    
    @IBAction func didChangeSegment(sender: UISegmentedControl) {
            
        switch(sender.selectedSegmentIndex){
            case 0: sorting = 0
            case 1: sorting = 1
            default: println("Error")
            }
        taskTable.reloadData()
    }
    
    func getTask() -> TaskObject {
        var task = taskModel.getTask(currentRow)
        return task
    }
    func deleteOldTask() -> Void {
        taskModel.deleteTask(currentRow)
    }
}

