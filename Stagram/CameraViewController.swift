//
//  CameraViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import ALCameraViewController

class CameraViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    override func viewDidAppear(animated: Bool) {
        if selectedImage == nil{
            showPhotoLibrary()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showCamera()
    }
    
    @IBAction func cameraButtonClicked(sender: UIBarButtonItem) {
        showPhotoLibrary()
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        selectedImage = image
        selectedImageView.image = selectedImage
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        print (image.description)
        
    }
    
    func showPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

//    func showCamera(){
//        let croppingEnabled = true
//        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled) { image in
//            print(image?.description)
//        }
//        presentViewController(cameraViewController, animated: true, completion: nil)
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
