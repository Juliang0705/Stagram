//
//  UserMedia.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func postProfieImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?){
        
        let query = PFQuery(className: "ProfileImage")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (profiles, error) -> Void in
            if error == nil && profiles!.count != 0{
                let oldProfile = profiles!.first!
                oldProfile["image"] = getPFFileFromImage(image)
                oldProfile.saveInBackgroundWithBlock(completion)
            }else{
                print(error)
                let profile = PFObject(className: "ProfileImage")
                profile["image"] = getPFFileFromImage(image)
                profile["owner"] = PFUser.currentUser()
                profile["username"] = PFUser.currentUser()!.username
                profile.saveInBackgroundWithBlock(completion)
            }
        }
    }
    
    class func fetchProfileImage(user user: PFUser, completion: (UIImage?,NSError?) -> ()){
            let query = PFQuery(className: "ProfileImage")
        query.whereKey("username", equalTo: user.username!)
            query.findObjectsInBackgroundWithBlock({ (profiles, error) -> Void in
                if error == nil && profiles!.count != 0{
                    let profile = profiles!.first!
                    let imagefile = profile.objectForKey("image") as? PFFile
                    print("Image is \(imagefile)")
                    imagefile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                        if (error == nil){
                            let image = UIImage(data: data!)
                            completion(image,nil)
                        }else{
                            completion(nil,error)
                        }
                    })
                }else{
                    completion(nil,error)
                }
            })
    }
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
