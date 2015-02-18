//
//  InputViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/02/16.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit
import Realm

class InputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var picker: UIPickerView!

    var editDelegate:EditDelegate?
    var editingTask:TaskObject!
    var edit = false
    var row = 0
    var input = InputModel()
    var selectedYear = 0
    var selectedMonth = 0
    var selectedDate = 0
    var selectedPriority = 5

    var month = 0
    var year = 0
    var date = 0
    
    let realm = RLMRealm.defaultRealm()
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self
        
        month = input.getMonth()
        year = input.getYear()
        date = input.getDate()
        
        selectedDate = date
        selectedYear = year
        selectedMonth = month
        
        detail.layer.borderWidth = 0.3
        detail.layer.cornerRadius = 0
        name.delegate = self
        detail.delegate = self
        
        
        if edit {
            editingTask = editDelegate!.getTask()
            selectedYear = editingTask.firstComp + year
            selectedMonth = editingTask.secondComp + 1
            selectedDate = editingTask.thirdComp + 1
            self.title = "Edit Task"
            self.name.text = editingTask.name
            self.detail.text = editingTask.detail
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if edit {
            picker.selectRow(editingTask.firstComp, inComponent: 0, animated: true)
            picker.selectRow(editingTask.secondComp, inComponent: 1, animated: true)
            picker.selectRow(editingTask.thirdComp, inComponent: 2, animated: true)
            picker.selectRow(editingTask.priority - 1, inComponent: 3, animated: true)
        }else {
            picker.selectRow(month-1, inComponent: 1, animated: true)
            println("selectedMonth = \(selectedMonth)")
            picker.selectRow(1, inComponent: 3, animated: true)
            println("selectedDate = \(selectedDate)")
            println(date)
            picker.selectRow(date-1, inComponent: 2, animated: true)
        }
    }
    

    
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 1000
        case 1: return 12
        case 2: switch selectedMonth {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: if (selectedYear % 4 == 0) && (selectedYear % 100 == 0) {
                    if selectedYear % 400 == 0 {
                        return 29
                    }else {return 28}
        }else if selectedYear % 4 == 0 && selectedYear % 100 != 0 {
            return 29
        }else {
            return 28
            }
        default: return 1
            }
        case 3: return 3
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
        case 2: var day = input.getDay(selectedYear, month: selectedMonth, date: row+1)
            
            return "\(row+1)日(\(day))"
        case 3: return "\(row+1)"
        default: break
        }
        
        
        return "error"
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return 85
        case 1: return 60
        case 2: return 95
        case 3: return 40
        default: return 0
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("\(row) \(component)")
        switch component {
        case 0: selectedYear = row + year
            picker.reloadComponent(2)
        case 1: selectedMonth = row + 1
            picker.reloadComponent(2)
        case 2: selectedDate = row + 1
        case 3: selectedPriority = row + 1
        default : break
        }
        
        println("picker is selected.")
    }
    
    
    

    @IBAction func didTapSaveButton(sender: AnyObject) {
        
        if edit {
            editDelegate?.deleteOldTask()
            
        }
        
        if name.text != "" {
            let task = TaskObject()
            task.name = name.text
            task.detail = detail.text
            task.priority = picker.selectedRowInComponent(3) + 1
            task.date = "\(selectedYear)\(selectedMonth)\(selectedDate)".toInt()!
            task.displayDate = "\(selectedYear)/\(selectedMonth)/\(selectedDate)(\(input.getDay(selectedYear, month: selectedMonth, date: selectedDate)))"
            task.firstComp = picker.selectedRowInComponent(0)
            task.secondComp = picker.selectedRowInComponent(1)
            task.thirdComp = picker.selectedRowInComponent(2)
            realm.beginWriteTransaction()
            realm.addObject(task)
            realm.commitWriteTransaction()
            for taskName in TaskObject.allObjects() {
                println("\((taskName as TaskObject).name)")
            }
            
            println("save complete.")
            
            name.text = ""
            detail.text = ""
            
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func textFieldShouldReturn(textField:UITextField) {
        textField.resignFirstResponder()
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
        textView.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.name.resignFirstResponder()
        self.detail.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        edit = false
    }
}

protocol EditDelegate {
    func getTask() -> TaskObject
    func deleteOldTask() -> Void
}
