//
//  TaskTableModel.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/17.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit
import Realm

class TaskTableModel: NSObject {
   
    let realm = RLMRealm.defaultRealm()
    var tasks:[TaskObject] = [TaskObject]()
    var num = 0
    
    func getTodayForDisplay() -> String {
        var comp = NSDateComponents()
        var cal = NSCalendar.currentCalendar()
        var today = NSDate()
        var day = String()
        comp = cal.components((NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitHour|NSCalendarUnit.CalendarUnitMinute), fromDate: today)
        switch comp.weekday {
        case 1: day = "日"
        case 2: day = "月"
        case 3: day = "火"
        case 4: day = "水"
        case 5: day = "木"
        case 6: day = "金"
        case 7: day = "土"
        default: day = "error"
        }
        return "今日：\(comp.year)/\(comp.month)/\(comp.day)(\(day))"
    }
    
    func getToday() -> Int {
        var comp = NSDateComponents()
        var cal = NSCalendar.currentCalendar()
        var today = NSDate()
        comp = cal.components((NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate: today)
        let month2dig = NSString(format: "%02d", comp.month)
        let date2dig = NSString(format: "%02d", comp.day)
        return "\(comp.year)\(month2dig)\(date2dig)".toInt()!
    }
    
    func getTaskList() {
        for num in TaskObject.allObjects() {
            tasks.append(num as TaskObject)
        }
    }
    
    func sortTasks() -> [TaskObject] {
        var task = [TaskObject]()
        for k in TaskObject.allObjects() {
            task.append(k as TaskObject)
        }
        task.sort({
            $0.priority > $1.priority
        })
        task.sort({
            $0.date < $1.date
        })
        
        task.sort({
            Int($0.completion) < Int($1.completion)
        })
        var l = 0
        for k in task {
            realm.beginWriteTransaction()
            k.number = l
            realm.commitWriteTransaction()
            l++
            println("\(k.name), \(k.number)")
        }
        
        return task
    }
    
    func sortTasksPriority() -> [TaskObject] {
        var task = [TaskObject]()
        for k in TaskObject.allObjects() {
            task.append(k as TaskObject)
        }
        task.sort({
            $0.date < $1.date
        })
        task.sort({
            $0.priority > $1.priority
        })
        task.sort({
            Int($0.completion) < Int($1.completion)
        })
        var l = 0
        for k in task {
            realm.beginWriteTransaction()
            k.number = l
            realm.commitWriteTransaction()
            l++
            println("\(k.name), \(k.number)")
        }
        return task
    }
    
    
    func getNumberOfTasks() -> Int {
        var j = 0
        var task = [TaskObject]()
        for m in TaskObject.allObjects() {
            task.append(m as TaskObject)
        }
        for ; j < task.count; j++ {
            println("セル数\(j)")
        }
        num = j
        return j
    }
    
    func deleteTask(row: Int) {

        var task = [TaskObject]()
        for m in TaskObject.allObjects() {
            task.append(m as TaskObject)
        }

        realm.beginWriteTransaction()
        realm.deleteObjects(TaskObject.objectsWhere("number = %d", row))
        realm.commitWriteTransaction()

        task.removeAtIndex(row)
    }
    
    func complete(row:Int) {
        var compl = TaskObject.objectsWithPredicate(NSPredicate(format: "number = %d", row))
        for i in compl {
            // book name:realm tutorial 1
            realm.beginWriteTransaction()
            if (i as TaskObject).completion == false {
                (i as TaskObject).completion = true
            }else if (i as TaskObject).completion == true {
                (i as TaskObject).completion = false
            }
            println("\((i as TaskObject).completion)")
            realm.commitWriteTransaction()
        }
    }
    
    func getTask(row:Int) -> TaskObject {
        for i in TaskObject.allObjects() {
            if (i as TaskObject).number == row {
                return (i as TaskObject)
            }
        }
        return TaskObject()
    }
}
