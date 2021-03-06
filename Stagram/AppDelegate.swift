//
//  AppDelegate.swift
//  Stagram
//
//  Created by Juliang Li on 2/22/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let UserDidLogOut = "UserDidLogOut"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Stagram"
                configuration.clientKey = "wuihdakjscy4981489urdwi"
                configuration.server = "https://frozen-woodland-76241.herokuapp.com/parse"
            })
        )
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 37/255.0, green: 72/255.0, blue: 116/225.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(red: 37/255.0, green: 72/255.0, blue: 116/225.0, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        if PFUser.currentUser() != nil {
            print("Detect current User: \(PFUser.currentUser()!.username!)")
            let tabViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Entry") as! TabViewController
            let activityString = "\(PFUser.currentUser()!.username!) signed in to Stagram :)"
            UserMedia.postUserActivity(activity: activityString, completion: { (succ, error) -> Void in })
            window?.rootViewController = tabViewController
            window?.makeKeyAndVisible()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogOut", name: UserDidLogOut, object: nil)
        return true
    }
    
    func userDidLogOut(){
        let signInViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SignIn") as! SignInViewController
        window?.rootViewController = signInViewController
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

