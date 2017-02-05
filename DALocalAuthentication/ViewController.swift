//
//  ViewController.swift
//  DALocalAuthentication
//
//  Created by Dejan on 05/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import UIKit

private struct Constants {
    static let UserVCID = "UserViewController"
}

class ViewController: UIViewController {

    var loginController: LoginProtocol = LoginController()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Checking TouchID here... Just for demo!
        loginController.loginDeviceOwner { (ownerID) in
            print("didLoginOwner: ", ownerID ?? "NO OWNER")
            if let owner = ownerID {
                self.presentUserScreen(user: owner)
            } else {
                print("Could not authenticate owner")
            }
        }
    }

    @IBAction func loginAction() {
        if let user = userNameTextField.text, let pass = passwordTextField.text {
            loginController.login(userName: user, password: pass, onLogin: { (success) in
                print("didLogin: ", success)
                if success == true {
                    self.presentUserScreen(user: user)
                } else {
                    print("Login failed")
                }
            })
        }
    }
    
    @IBAction func resetOwnerAction() {
        loginController.resetOwner()
    }
    
    private func presentUserScreen(user: String) {
        if let userVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.UserVCID) as? UserViewController {
            userVC.currentUser = user
            self.present(userVC, animated: true, completion: nil)
        }
    }
}

