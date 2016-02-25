//
//  CameraViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import ALCameraViewController

func resize(image: UIImage, newSize: CGSize) -> UIImage {
    let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
    resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
    resizeImageView.image = image
    
    UIGraphicsBeginImageContext(resizeImageView.frame.size)
    resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}

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
        selectedImage = resize(image, newSize: CGSizeMake(selectedImageView.frame.width, selectedImageView.frame.height))
        
        selectedImageView.image = addCaptionToImage(caption: "Hello It is me", inImage: selectedImage!, atPoint: CGPointMake(0, 300),fontSize: 30)
        
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

    func addCaptionToImage(caption caption:String, inImage: UIImage, atPoint: CGPoint,fontSize :CGFloat) -> UIImage{
        // Setup the font specific variables
        let textColor: UIColor = UIColor.whiteColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: fontSize)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        caption.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
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
