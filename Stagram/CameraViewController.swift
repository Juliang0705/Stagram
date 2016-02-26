//
//  CameraViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import ALCameraViewController
import BFRadialWaveHUD

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

class CameraViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    @IBOutlet weak var selectedImageView: UIImageView!
    var captionTextField: UITextField?
    var loadingView: BFRadialWaveHUD!
    override func viewDidAppear(animated: Bool) {
        if selectedImage == nil{
            showPhotoLibrary()
        }
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KeyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "ShowCaptionTextField:")
        self.view.addGestureRecognizer(tapRecognizer)
        loadingView = BFRadialWaveHUD(view: self.view, fullScreen: true, circles: BFRadialWaveHUD_DefaultNumberOfCircles, circleColor: nil, mode: BFRadialWaveHUDMode.Default, strokeWidth: BFRadialWaveHUD_DefaultCircleStrokeWidth)
        loadingView.blurBackground = true
        
    }
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func cameraButtonClicked(sender: UIBarButtonItem) {
        showPhotoLibrary()
    }
    
    func ShowCaptionTextField(tap : UITapGestureRecognizer){
        if (captionTextField == nil){
            let tapPosition = tap.locationInView(self.view)
            let textField = UITextField(frame: CGRect(x: 0, y: tapPosition.y, width: self.view.bounds.width, height: 35))
            textField.textColor = UIColor.whiteColor()
            textField.borderStyle = .None
            textField.textAlignment = .Center
            textField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            textField.font = UIFont(name: "", size: 20)
            self.captionTextField = textField
            self.captionTextField?.tag = Int(tapPosition.y)
            self.captionTextField?.delegate = self
            self.captionTextField?.addPanGesture()
            self.view.addSubview(self.captionTextField!)
            textField.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    func KeyboardWillShow(notification: NSNotification){
        if (self.captionTextField != nil){
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.captionTextField!.textAlignment = .Left
                self.captionTextField!.frame.origin.y = keyboardSize.origin.y - keyboardSize.height - self.captionTextField!.bounds.height
            }
        }
    }
    
    func KeyboardWillHide(notification: NSNotification){
        if (self.captionTextField != nil){
            if (self.captionTextField!.text == ""){
                self.captionTextField!.removeFromSuperview()
                self.captionTextField = nil
            }else{
                self.captionTextField!.textAlignment = .Center
                self.captionTextField!.frame.origin.y = CGFloat(self.captionTextField!.tag)
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        selectedImage = resize(image, newSize: CGSizeMake(selectedImageView.frame.width, selectedImageView.frame.height))
        selectedImageView.image = selectedImage
        self.captionTextField?.removeFromSuperview()
        self.captionTextField = nil
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
    
// this method is never used
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

    @IBAction func sharedButtonClicked(sender: UIBarButtonItem) {
        let imageWithCaption = self.view.getImageWithAllSubviews()
        let caption = self.captionTextField?.text
        loadingView.showWithMessage("Uploading")
        UserMedia.postUserImage(imageWithCaption, withCaption: caption) { (success, error) -> Void in
            self.loadingView.dismiss()
            if error == nil{
                showWarningViewWithMessage("Picture Shared!", title: "Success", parentViewController: self)
                tabViewController?.selectedIndex = 0
            }else{
                showWarningViewWithMessage(error!.localizedDescription, title: "Error: \(error!.code)", parentViewController: self)
            }
        }
    }
}

extension UIView {
    func getImageWithAllSubviews() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
}


extension UITextField{
    
    func addPanGesture(){
        let panRecognizer = UIPanGestureRecognizer(target:self, action:"handlePan:")
        self.addGestureRecognizer(panRecognizer)
    }
    func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x,
                y:view.center.y + translation.y)
            if (!checkTextFieldWithinBoundaryOfSuperView(lowerBound: 0.2, upperBound: 0.8)){
                view.center = CGPoint(x:view.center.x,
                    y:view.center.y - translation.y)
            }
            self.tag = Int(view.center.y)
                
        }
        recognizer.setTranslation(CGPointZero, inView: self)
    }
    func checkTextFieldWithinBoundaryOfSuperView(lowerBound lowerBound:CGFloat, upperBound: CGFloat) -> Bool{
        if let parent = self.superview{
            return self.center.y >  parent.frame.height * lowerBound && self.center.y <  parent.frame.height * upperBound
        }else{
            return false
        }
    }
}