//
//  SettingsViewController.swift
//  ToDo-Rev
//
//  Created by takayuki abe on 2015/03/24.
//  Copyright (c) 2015年 takayuki abe. All rights reserved.
//

import UIKit
import NYXImagesKit

class SettingsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDelegate {

    @IBOutlet weak var settingsTableView: UITableView!
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
    
    
    
}
