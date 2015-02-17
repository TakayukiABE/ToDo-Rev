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
            $0.date > $1.date
        })
        return task
    }
    
    func getNumberOfTasks() -> Int {
        var j = 0
        for ; j < tasks.count; j++ {
            println("セル数\(j)")
        }
        num = j
        return j
    }
    
    func deleteTask(row: Int, taskName:String) {

        tasks.removeAtIndex(row)
        
        
        realm.beginWriteTransaction()
        realm.deleteObjects(TaskObject.objectsWhere("name = '\(taskName)'"))
        
        
        
        realm.commitWriteTransaction()
        
        
        
        
    }
}
