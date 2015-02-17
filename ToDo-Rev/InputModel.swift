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
    func getDate() -> Int {
        return comp.day
    }
 
    func getDay(year:Int, month:Int, date:Int) -> Int {
        var searchDate:NSDate = cal.dateWithEra(1, year: year, month: month, day: date, hour: 9, minute: 0, second: 0, nanosecond: 0)!
        var component = cal.components((NSCalendarUnit.CalendarUnitWeekday), fromDate: searchDate)
        println("曜日は\(component.weekday)")
        println("Dateは\(searchDate)")
        return component.weekday
    }
}
