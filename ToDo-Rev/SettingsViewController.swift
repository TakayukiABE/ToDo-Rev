//
//  SettingsViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/03/24.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    let controller = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        controller.delegate = self
        controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    

    @IBAction func didTapCamerabutton(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            let resizedImage = resizeImage(image)
            
            
            let imageData:NSData = UIImagePNGRepresentation(resizedImage)
            
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
