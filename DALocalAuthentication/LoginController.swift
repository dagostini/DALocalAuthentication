//
//  LoginController.swift
//  DALocalAuthentication
//
//  Created by Dejan on 05/02/2017.
//  Copyright © 2017 Dejan. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol LoginProtocol {
    func loginDeviceOwner(ownerID: @escaping (String?) -> ())
    func login(userName: String, password: String, onLogin: (Bool) -> ())
    func resetOwner()
}

private struct LoginConstants {
    static let OwnerKey = "DALocalAuthentication.OwnerKey"
    static let TouchIDReason = "Use TouchID to log you in quickly!"
}

class LoginController: LoginProtocol {
    
    func loginDeviceOwner(ownerID: @escaping (String?) -> ()) {
        
        guard getOwnerID() != nil else {
            ownerID(nil)
            return
        }
        
        authenticateDeviceOwner { (success) in
            if success == true {
                DispatchQueue.main.async {
                    ownerID(self.getOwnerID())
                }
            } else {
                DispatchQueue.main.async {
                    ownerID(nil)
                }
            }
        }
    }
    
    func login(userName: String, password: String, onLogin: (Bool) -> ()) {
        
        // Hardcoded password check... Just for demo!
        if password == "1234" {
            
            if getOwnerID() == nil {
                authenticateDeviceOwner(onAuthenticate: { (success) in
                    if success == true {
                        self.saveOwnerID(ownerID: userName)
                    }
                })
            }
            onLogin(true)
        } else {
            onLogin(false)
        }
    }
    
    func resetOwner() {
        removeOwnerID()
    }
    
    private func authenticateDeviceOwner(onAuthenticate: @escaping (Bool) -> ()) {
        
        let context = LAContext()
        let reason = LoginConstants.TouchIDReason
        var error: NSError? = nil
        
        if #available(iOS 8.0, *) {
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                    onAuthenticate(success)
                })
            } else {
                onAuthenticate(false)
            }
        } else {
            onAuthenticate(false)
        }
    }
    
    private func saveOwnerID(ownerID: String) {
        UserDefaults.standard.set(ownerID, forKey: LoginConstants.OwnerKey)
    }
    
    private func getOwnerID() -> String? {
        return UserDefaults.standard.value(forKey: LoginConstants.OwnerKey) as? String
    }
    
    private func removeOwnerID() {
        UserDefaults.standard.removeObject(forKey: LoginConstants.OwnerKey)
    }
}

