//
//  InputViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/16.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!

    var input = InputModel()
    
    var selectedYear = 0
    var selectedMonth = 0
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self
        var month = input.getMonth()
        picker.selectRow(month-1, inComponent: 1, animated: false)
        selectedMonth = month
        println("selectedMonth = \(selectedMonth)")
        picker.selectRow(4, inComponent: 3, animated: false)
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 1000
        case 1: return 12
        case 2: switch selectedMonth {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return 28
        default: return 1
            }
        case 3: return 10
        default: return 1
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var year = input.getYear()
       // var date = input.getDate()
        var day = String()
        switch component {
        case 0: return "\(year+row)年"
        case 1: return "\(row+1)月"
        case 2: return "\(row+1)日(曜)"
        case 3: return "\(row+1)"
        default: break
        }
        
        
        return "a"
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return 85
        case 1: return 50
        case 2: return 95
        case 3: return 40
        default: return 0
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("\(row) \(component)")
        switch component {
        case 1: selectedMonth = row + 1
            picker.reloadComponent(2)
        default : break
        }
        
        println("picker is selected.")
    }
}
