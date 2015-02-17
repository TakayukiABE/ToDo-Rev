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
   
    var tasks:[TaskObject] = [TaskObject]()
    
    func getTaskList() {
        for num in TaskObject.allObjects() {
            tasks.append(num as TaskObject)
        }
    }
    
    func sortTasks() -> [TaskObject] {
        tasks.sort({
            $0.date > $1.date
        })
        
        return tasks
    }
    
    func getNumberOfTasks() -> Int {
        var num = 0
        for ; num < tasks.count; num++ {
        }
        return num
    }
}
