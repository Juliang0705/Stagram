//
//  TabViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/24/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit

var tabViewController: TabViewController?

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUserinfo()
        setUpTabs()
        tabViewController = self
    }
    
    func initUserinfo(){
        UserMedia.initProfileImage { (object, error) -> () in
            if error == nil{
                profileImageObject = object
            }else{
                print("Fatal Error: \(error!)")
            }
        }
        
        UserMedia.initSharedImagedCount { (object, error) -> () in
            if error == nil{
                postCountObject = object
            }else{
                print("Fatal Error: \(error!)")
            }
        }
    }
    func setUpTabs(){
        let homeScreenNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeScreen") as? UINavigationController
        
        let homeScreenViewController = homeScreenNavigationController?.topViewController
        homeScreenViewController?.title = "Home"
        
        homeScreenNavigationController?.tabBarItem.title = "Home"
        homeScreenViewController?.tabBarItem.image = UIImage(named: "home")
        //------------------------------------------------------------------------------
        let searchNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Search") as? UINavigationController
        
        let searchViewController = searchNavigationController?.topViewController
        searchViewController?.title = "Search"
        
        searchNavigationController?.tabBarItem.title = "Search"
        searchNavigationController?.tabBarItem.image = UIImage(named: "search")
        //------------------------------------------------------------------------------
        
        let cameraNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Camera") as? UINavigationController
        
        let cameraViewController = cameraNavigationController?.topViewController
        cameraViewController?.title = "Upload"
        
        cameraNavigationController?.tabBarItem.title = "Upload"
        cameraNavigationController?.tabBarItem.image = UIImage(named: "upload")
        //------------------------------------------------------------------------------

        let activityNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Activity") as? UINavigationController
        
        let activityViewController = activityNavigationController?.topViewController
        activityViewController?.title = "Activity"
        
        activityNavigationController?.tabBarItem.title = "Activity"
        activityNavigationController?.tabBarItem.image = UIImage(named: "activity")
        
        //------------------------------------------------------------------------------

        let userNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("User") as? UINavigationController
        
        let userViewController = userNavigationController?.topViewController
        userViewController?.title = "Me"
        
        userNavigationController?.tabBarItem.title = "User"
        userNavigationController?.tabBarItem.image = UIImage(named: "user")
        //------------------------------------------------------------------------------
        self.viewControllers = [homeScreenNavigationController!,searchNavigationController!,cameraNavigationController!,activityNavigationController!,userNavigationController!]
        
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
