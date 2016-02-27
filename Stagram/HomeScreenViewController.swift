//
//  HomeScreenViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse
let HomeScreenHeaderViewIdentifier: String = "HomeScreenHeaderViewIdentifier"

class HomeScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var sharedPosts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 480
        tableView.registerNib(UINib(nibName: "HomeScreenHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: HomeScreenHeaderViewIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("getting data")
        UserMedia.fetchHomeScreenImages { (objects, error) -> () in
            if error == nil{
                self.sharedPosts = objects
                self.tableView.reloadData()
            }else{
                print("Terrible thing just happened")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sharedPosts = self.sharedPosts{
            return sharedPosts.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeScreenCell", forIndexPath: indexPath) as! HomeScreenCell
        let post = sharedPosts![indexPath.section]
        let imageFile = post.objectForKey("media") as? PFFile
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if (error == nil){
                cell.sharedImageView.image = UIImage(data: data!)
            }else{
                print("Cannot get image for index \(indexPath.row)")
            }
        })
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HomeScreenHeaderViewIdentifier) as! HomeScreenHeaderView
        let post = sharedPosts![section]
        let profileImageObject = post.objectForKey("profileImage") as? PFObject
        let imageFile = profileImageObject?.objectForKey("image") as? PFFile
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            if error == nil{
                header.profileImageView.image = UIImage(data: data!)
            }else{
                print("Cannot get profile image for index \(section)")
            }
        })
        
        let username = profileImageObject?.objectForKey("username") as? String
        header.usernameLabel.text = username!
        header.timeLabel.text = getTimePastFromDate(post.createdAt!)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewProfile:")
        
        header.profileImageView.userInteractionEnabled = true
        header.profileImageView.tag = section
        header.addGestureRecognizer(tapRecognizer)
        
        header.usernameLabel.userInteractionEnabled = true
        header.usernameLabel.tag = section
        header.addGestureRecognizer(tapRecognizer)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    func viewProfile(tap: UITapGestureRecognizer){
        if tap.state != .Ended{
            return
        }
        let index = tap.view?.tag
        if let index = index{
            let sharedPost = self.sharedPosts?[index]
            let user = sharedPost?.objectForKey("author") as? PFUser
            self.performSegueWithIdentifier("profile", sender: user)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let user = sender as? PFUser{
            if let userProfileViewController = segue.destinationViewController as? UserViewController{
                userProfileViewController.selectedUser = user
            }
        }
    }

}
func getTimePastFromDate(date: NSDate) -> String{
    let time = Int(NSDate().timeIntervalSinceDate(date))
    return convertTimeToString(time)
}

func convertTimeToString(number: Int) -> String{
    let day = number/86400
    let hour = (number - day * 86400)/3600
    let minute = (number - day * 86400 - hour * 3600)/60
    if day != 0{
        return String(day) + "d"
    }else if hour != 0 {
        return String(hour) + "h"
    }else{
        return String(minute) + "m"
    }
}