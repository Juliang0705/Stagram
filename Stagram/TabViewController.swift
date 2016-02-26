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
        setUpTabs()
        tabViewController = self
    }
    
    func setUpTabs(){
        let homeScreenNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeScreen") as? UINavigationController
        
        let homeScreenViewController = homeScreenNavigationController?.topViewController
        homeScreenViewController?.title = "Home"
        
        homeScreenNavigationController?.tabBarItem.title = "Home"
        //------------------------------------------------------------------------------
        let searchNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Search") as? UINavigationController
        
        let searchViewController = searchNavigationController?.topViewController
        searchViewController?.title = "Search"
        
        searchNavigationController?.tabBarItem.title = "Search"
        //------------------------------------------------------------------------------
        
        let cameraNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Camera") as? UINavigationController
        
        let cameraViewController = cameraNavigationController?.topViewController
        cameraViewController?.title = "Upload"
        
        cameraNavigationController?.tabBarItem.title = "Upload"
        //------------------------------------------------------------------------------

        let activityNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("Activity") as? UINavigationController
        
        let activityViewController = activityNavigationController?.topViewController
        activityViewController?.title = "Activity"
        
        activityNavigationController?.tabBarItem.title = "Activity"
        
        //------------------------------------------------------------------------------

        let userNavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("User") as? UINavigationController
        
        let userViewController = userNavigationController?.topViewController
        userViewController?.title = "Me"
        
        userNavigationController?.tabBarItem.title = "User"
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
