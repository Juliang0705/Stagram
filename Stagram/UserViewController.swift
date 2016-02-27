//
//  UserViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var selectedUser: PFUser?
    var imagePicker = UIImagePickerController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedUser == nil{
            selectedUser = PFUser.currentUser()
        }
        usernameLabel.text = selectedUser?.username!
        if (selectedUser!.objectId! == PFUser.currentUser()!.objectId!){
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "changeProfilePicture")
            profileImageView.userInteractionEnabled = true
            profileImageView.addGestureRecognizer(tapRecognizer)
        }else{
            signOutButton.enabled = false
            signOutButton.title = ""
        }
        getUserProfilePicture()
        getUserPostImageCount()
    }

    @IBAction func signOutButtonClicked(sender: UIBarButtonItem) {
        let activityString = "\(PFUser.currentUser()!.username!) logged out of Stagram :("
        UserMedia.postUserActivity(activity: activityString, completion: { (succ, error) -> Void in })
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(UserDidLogOut,object: nil)
    }
    
    func changeProfilePicture(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
        print (image.description)
        let size = self.profileImageView.frame.size
        let resizedImage = resize(image, newSize: size)
        UserMedia.postProfieImage(resizedImage) { (success, error) -> Void in
            if error == nil{
                self.getUserProfilePicture()
                let activityString = "\(PFUser.currentUser()!.username!) changed profile image."
                UserMedia.postUserActivity(activity: activityString, completion: { (succ, error) -> Void in })
            }else{
                showWarningViewWithMessage(error!.localizedDescription, title: "Upload Failed", parentViewController: self)
            }
        }
    }
    
    
    func getUserProfilePicture(){
        UserMedia.fetchProfileImage(user: selectedUser!) { (image, error) -> () in
            if error == nil && image != nil{
                self.profileImageView.image = image
            }else{
                print("Picture getting failed: \(error)")
            }
        }
    }
    
    func getUserPostImageCount(){
        UserMedia.fetchPostImageCount(user: selectedUser!) { (count, error) -> () in
            if (error == nil && count != nil){
                self.postCountLabel.text = "\(count!)"
            }else{
                self.postCountLabel.text = "0"
            }
        }
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
