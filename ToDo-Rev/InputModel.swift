//
//  InputModel.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/16.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit

class InputModel: NSObject {
    
    var comp = NSDateComponents()
    var cal = NSCalendar.currentCalendar()

    
    override init() {
        var today = NSDate()
        comp = cal.components((NSCalendarUnit.CalendarUnitWeekday|NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitYear), fromDate: today)
        println(comp.year)
    }
    
    func getYear() -> Int {
        return comp.year
    }
    
    func getMonth() -> Int {
        return comp.month
    }
    
}
