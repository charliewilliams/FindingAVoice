//
//  UserHandler.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 19/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import FirebaseCore

/*
 Check if we have a local user. 
 
 If we do, tell Fabric about this session.
 
 If we don't, pop up the "Who are you anyway?" screen.
 */

class UserHandler {
    
    static let instance = UserHandler()
    private init() { }
    
    var user: User? {
        didSet {
            if let user = user {
                Analytics.configure(withUser: user)
            }
        }
    }
    
    var hasLocalUser: Bool {
        return store.string(forKey: "email") != nil
    }
    
    var email: String? {
        get { return store.string(forKey: "email") }
        set(newValue) { store.set(newValue, forKey: "email") }
    }
    
    var password: String? {
        get { return store.string(forKey: "password") }
        set(newValue) { store.set(newValue, forKey: "password") }
    }
    
    func handleSessionStart() {
        
        ServerCoordinator.shared.handleAppLaunch(email: email, password: password) { (user, error) in

            if let user = user, self.user == nil { // Don't overwrite if weird async stuff is happening
                self.user = user
            } else {
                self.showSignupScreen()
            }
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping LoginCompletion) {
        
        self.email = email
        self.password = password
        
        ServerCoordinator.shared.createUser(email: email, password: password) { (user, error) in
            
            if self.user == nil { // Don't overwrite if weird async stuff is happening
                self.user = user
            }
            
            completion(user, error)
        }
        
        Answers.logCustomEvent(withName: "UserSignup", customAttributes: ["email": email])
    }
}

private extension UserHandler {
    
    var store: UserDefaults {
        return UserDefaults.standard
    }
    
    var logger: Crashlytics {
        return Crashlytics.sharedInstance()
    }
    
    func showSignupScreen() {
        
        presentViewController(SignupViewController())
    }
    
    func bail() {
        
        let alert = UIAlertController(title: "Data error", message: "Something has gone wrong. Please delete and reinstall the app, or your data will not be recorded properly.", preferredStyle: .alert)
        
        presentViewController(alert)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        
        delay(1) {
            UIApplication.shared.keyWindow!.rootViewController!.present(viewController, animated: true, completion: nil)
        }
    }
}
