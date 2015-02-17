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
            $0.date < $1.date
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
            }else {
                (i as TaskObject).completion = false
            }
            println("\((i as TaskObject).completion)")
            realm.commitWriteTransaction()
        }
        
    }
}
