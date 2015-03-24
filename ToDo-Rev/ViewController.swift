//
//  ViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/15.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit


import NYXImagesKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditDelegate {
    @IBOutlet weak var taskTable: UITableView!
    
    @IBOutlet weak var todayLabel: UILabel!

    var numOfTask = 0
    var taskModel = TaskTableModel()
    var taskName = String()
    var sorting = 0
    var currentRow = 0
    var today = 0
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        super.viewDidLoad()
        initLabel()
        taskTable.delegate = self
        taskTable.dataSource = self
        self.view.backgroundColor = UIColor.blueColor()
        taskModel.getTaskList()
        println("number of tasks = \(numOfTask)")
        taskTable.alpha = 1.0
        today = taskModel.getToday()
        
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = event.allTouches()?.anyObject()! as UITouch
        println(touch.view.tag)
        switch(touch.view.tag){
        case 0:
            todayLabel.text = taskModel.getTodayForDisplay()
            today = taskModel.getToday()
            taskTable.reloadData()
        default:
            break
        }
    }
    
    func initLabel() {
        todayLabel.text = taskModel.getTodayForDisplay()
        todayLabel.backgroundColor = UIColor(red: 0.97, green: 0.93, blue: 0.6, alpha: 0.9)
        todayLabel.layer.borderWidth = 0.3
        todayLabel.tag = 0
        todayLabel.userInteractionEnabled = true
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        
        if today > tasks[indexPath.row].date && tasks[indexPath.row].completion == false {
            cell.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
        }else if today == tasks[indexPath.row].date && tasks[indexPath.row].completion == false {
            cell.backgroundColor = UIColor(red: 0.97, green: 0.93, blue: 0.6, alpha: 1.0)
        }else if tasks[indexPath.row].date - today == 1 {
            cell.backgroundColor = UIColor(red: 0.85, green: 1.0, blue: 0.85, alpha: 1.0)
        }else {
            var delta:CGFloat = (1.0 - CGFloat(tasks[indexPath.row].date - today)*0.001)
            if delta > 0.6 {
                cell.backgroundColor = UIColor(red: delta, green: delta, blue: delta, alpha: 1.0)
            }else {
                cell.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                cell.backgroundColor = UIColor.clearColor()
            }
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
        if num < 6 {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, 83 * CGFloat(num))
        }else {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, self.view.frame.height - 94)
        }
    }
    override func viewDidLayoutSubviews() {
//        if numOfTask < 6 {
//            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, 83 * CGFloat(numOfTask))
//        }else {
            taskTable.frame = CGRectMake(0, 94, self.view.frame.width, self.view.frame.height - 94)
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let alpha = NSUserDefaults.standardUserDefaults().objectForKey("alpha") as? CGFloat {
            taskTable.alpha = (alpha)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        taskTable.reloadData()
        if let imageData:NSData = NSUserDefaults.standardUserDefaults().objectForKey("background") as? NSData {
            let image = UIImage(data: imageData)
            
            
            self.view.backgroundColor = UIColor(patternImage: image!)
        }

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            taskModel.deleteTask(indexPath.row)
            numOfTask--
          //  update(numOfTask)
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

