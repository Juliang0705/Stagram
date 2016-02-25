//
//  ViewController.swift
//  Stagram
//
//  Created by Juliang Li on 2/22/16.
//  Copyright © 2016 Juliang. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var SignInButton: UIButton!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
    }

    @IBAction func SignInButtonClicked(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                showWarningViewWithMessage(error.localizedDescription, title: error.localizedFailureReason, parentViewController: self)
            } else {
                print("User logged in successfully")
                self.performSegueWithIdentifier("Entry", sender: self)
            }
        }
        
    }

    @IBAction func SignUpButtonClicked(sender: UIButton) {
        let newUser = PFUser()
        
        if (usernameField.text! == "" || passwordField.text! == ""){
            showWarningViewWithMessage("Fields cannot be empty", title: "Error", parentViewController: self)
            return
        }
        
        
        // set user properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        // call sign up function on the object
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                showWarningViewWithMessage(error.localizedDescription, title: error.localizedFailureReason, parentViewController: self)
                print(error.localizedFailureReason)
            } else {
                print("User Registered successfully")
                self.SignInButtonClicked(self.SignUpButton)
            }
        }
        
        
    }
    
    func initGUI(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        passwordField.secureTextEntry = true
        SignInButton.layer.cornerRadius = 10
        SignUpButton.layer.cornerRadius = 10
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


func showWarningViewWithMessage(message: String, title: String?,parentViewController: UIViewController){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
    parentViewController.presentViewController(alert,animated: true,completion: nil)
}

