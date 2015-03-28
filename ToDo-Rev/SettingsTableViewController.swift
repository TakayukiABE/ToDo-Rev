//
//  SettingsTableViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/03/25.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit
import Realm

class SettingsTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var alphaLabel: UILabel!
    
    let controller = UIImagePickerController()
    let realm = RLMRealm.defaultRealm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.tableView.allowsSelection = false
        self.tableView.scrollEnabled = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        if let alpha:Float = NSUserDefaults.standardUserDefaults().objectForKey("alpha") as? Float {
            alphaSlider.value = alpha * 10
            alphaLabel.text = "\(alpha)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }
    
    
    
    @IBAction func didTapCameraButton(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            // let resizedImage = resizeImage(image)
            let rImage = image.scaleToFitSize(CGSizeMake(320, 568))
            
            let imageData:NSData = UIImagePNGRepresentation(rImage)
            
            NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "background")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resizeImage(image:UIImage) -> UIImage {
        let size = CGSize(width: 320, height: 568)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
    @IBAction func didChangeValueForAlphaSlider(sender: UISlider) {
        let alpha = Int(sender.value)
        NSUserDefaults.standardUserDefaults().setObject(( Double(alpha) / 10.0), forKey: "alpha")
        alphaLabel.text = "\( Double(alpha) / 10.0)"
    }
    
    @IBAction func didTapDeleteCompletedTasksButton(sender: UIButton) {
        
        let actionSheet:UIAlertController = UIAlertController(title:"完了済みタスクの全削除",
            message: "完了済みタスクを全て削除しますか？",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "Delete",
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction!) -> Void in
                self.realm.beginWriteTransaction()
                self.realm.deleteObjects(TaskObject.objectsWhere("completion = true"))
                self.realm.commitWriteTransaction()
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })
        
        actionSheet.addAction(destructiveAction)
        actionSheet.addAction(cancelAction)
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    

    @IBAction func didTapDeleteImageButton(sender: UIButton) {
        let actionSheet:UIAlertController = UIAlertController(title:"背景画像の削除",
            message: "背景画像を削除しますか？",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "Delete",
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction!) -> Void in
                NSUserDefaults.standardUserDefaults().removeObjectForKey("background")
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })
        
        actionSheet.addAction(destructiveAction)
        actionSheet.addAction(cancelAction)
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
