//
//  TaskObject.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/17.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit

import Realm

class TaskObject: RLMObject {
    dynamic var date:Int = 0
    dynamic var name:String = ""
    dynamic var priority:Int = 0
    dynamic var detail:String = ""
    
    
}
