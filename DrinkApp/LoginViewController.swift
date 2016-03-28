//
//  LoginViewController.swift
//  DrinkApp
//
//  Created by Iavor Dekov on 3/16/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var loggedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        if textField == usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        if  username == "andy" && password == "andy" {
            view.endEditing(true)
            print("Successful login.")
            loggedIn = true
            performSegueWithIdentifier("LoginToDrinks", sender: self)
        }
        else if username != "andy" && password != "andy" {
            errorLabel.text = "Incorrect Username and Password"
            usernameTextField.becomeFirstResponder()
        }
        else if username != "andy" {
            errorLabel.text = "Incorrect Username"
            usernameTextField.becomeFirstResponder()
        }
        else if password != "andy" {
            errorLabel.text = "Incorrect Password"
            passwordTextField.becomeFirstResponder()
        }
    }

}
