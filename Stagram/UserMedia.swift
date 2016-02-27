//
//  UserMedia.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

var profileImageObject: PFObject?
var postCountObject: PFObject?

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
        media["profileImage"] = profileImageObject
        media["postCount"] = postCountObject
        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    class func fetchHomeScreenImages(completion completion:([PFObject]?, NSError?) -> ()){
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("profileImage")
        query.includeKey("postCount")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    
    class func fetchImagesWithSearch(search: String, completion:([PFObject]?, NSError?) -> ()){
        let query = PFQuery(className: "UserMedia")
        query.whereKey("caption", containsString: search)
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.includeKey("profileImage")
        query.includeKey("postCount")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
    }
    
    class func initProfileImage(completion: ((PFObject?,NSError?)->())){
        let query = PFQuery(className: "ProfileImage")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (profiles, error) -> Void in
            if error == nil && profiles!.count != 0{
                let oldProfile: PFObject = profiles!.first!
                completion(oldProfile,nil)
            }else{
                let profile = PFObject(className: "ProfileImage")
                profile["image"] = getPFFileFromImage(UIImage(named: "placeholder.png"))
                profile["owner"] = PFUser.currentUser()
                profile["username"] = PFUser.currentUser()!.username
                profile.saveInBackgroundWithBlock({ (succ, error) -> Void in
                    if error == nil{
                        completion(profile,nil)
                    }else{
                        completion(nil,error)
                    }
                })
            }
        }
    }
    
    class func initSharedImagedCount(completion: ((PFObject?,NSError?)->())){
        let query = PFQuery(className: "PostCount")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (profiles, error) -> Void in
            if error == nil && profiles!.count != 0{
                let profile = profiles!.first!
                completion(profile,nil)
            }else{
                let profile = PFObject(className: "PostCount")
                profile["count"] = 0
                profile["owner"] = PFUser.currentUser()
                profile["username"] = PFUser.currentUser()!.username
                profile.saveInBackgroundWithBlock({ (succ, error) -> Void in
                    if error == nil{
                        completion(profile,nil)
                    }else{
                        completion(nil,error)
                    }
                })
            }
        }
    }
    class func postProfieImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?){
        
        profileImageObject?["image"] = getPFFileFromImage(image)
        profileImageObject?.saveInBackgroundWithBlock(completion)
        
    }
    
    class func fetchProfileImage(user user: PFUser, completion: (UIImage?,NSError?) -> ()){
            let query = PFQuery(className: "ProfileImage")
        query.whereKey("username", equalTo: user.username!)
            query.findObjectsInBackgroundWithBlock({ (profiles, error) -> Void in
                if error == nil && profiles!.count != 0{
                    let profile = profiles!.first!
                    let imagefile = profile.objectForKey("image") as? PFFile
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
    
    class func postPostImageCount(count count: Int, completion: PFBooleanResultBlock){
        postCountObject?["count"] = count
        postCountObject?.saveInBackgroundWithBlock(completion)
    }
    
    class func incrementPostImageCount(completion: PFBooleanResultBlock){
        postCountObject?["count"] = (postCountObject?["count"] as! Int ) + 1
        postCountObject?.saveInBackgroundWithBlock(completion)
    }
    
    class func fetchPostImageCount(user user:PFUser, completion:(Int?,NSError?)->()){
        let query = PFQuery(className: "PostCount")
        query.whereKey("username", equalTo: user.username!)
        query.findObjectsInBackgroundWithBlock { (profiles, error) -> Void in
            if error == nil && profiles!.count != 0{
                let profile = profiles!.first!
                let count = profile.objectForKey("count") as? Int
                completion(count,nil)
            }else{
                completion(nil,error)
            }
        }
    }
    
    class func postUserActivity(activity activity: String, completion: PFBooleanResultBlock){
        let userActivity = PFObject(className: "UserActivity")
        userActivity["activity"] = activity
        userActivity["author"] = PFUser.currentUser()
        userActivity.saveInBackgroundWithBlock(completion)
    }
    
    class func fetchUserActivity(completion completion:([PFObject]?,NSError?)->()){
        let query = PFQuery(className: "UserActivity")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock(completion)
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
