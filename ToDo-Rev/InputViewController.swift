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
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self
        var month = input.getMonth()
        picker.selectRow(month-1, inComponent: 1, animated: false)
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 1000
        case 1: return 12
        case 2: return 30
        default: return 1
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var year = input.getYear()
        var month = input.getMonth()
        switch component {
        case 0: return "\(year+row)年"
        case 1: return "\(row+1)月"
        case 2: return "day日(曜)"
        default: break
        }
        
        
        return "a"
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("picker is selected.")
    }
}
