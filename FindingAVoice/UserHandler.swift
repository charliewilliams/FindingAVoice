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
import Firebase

/*
 Check if we have a local user. 
 
 If we do, tell Fabric about this session.
 
 If we don't, pop up the "Who are you anyway?" screen.
 */

class UserHandler {
    
    static let instance = UserHandler()
    private init() { }
    
    var user: FIRUser?
    
    var hasLocalUser: Bool {
        return store.string(forKey: "userId") != nil
    }
    
    var userId: String? {
        get { return store.string(forKey: "userId") }
        set(newValue) { store.set(newValue, forKey: "userId") }
    }
    
    var userName: String? {
        get { return store.string(forKey: "userName") }
        set(newValue) { store.set(newValue, forKey: "userName") }
    }
    
    func handleSessionStart() {
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            self.didLogIntoServer(user: user, error: error)
        }
    }
    
    func logUserSignup(name: String, id: String) {
        
        userId = id
        userName = name
        
        // save user info on user
        
        Answers.logCustomEvent(withName: "UserSignup", customAttributes: ["userId": id, "userName": name])
    }
}

private extension UserHandler {
    
    var store: UserDefaults {
        return UserDefaults.standard
    }
    
    var logger: Crashlytics {
        return Crashlytics.sharedInstance()
    }
    
    func didLogIntoServer(user: FIRUser?, error: Error?) {
        
        self.user = user
        
        // TODO handle error 
        
        if hasLocalUser {
            
            setUpStoredLocalUser()
            
        } else {
            
            showSignupScreen()
        }
    }
    
    func setUpStoredLocalUser() {
        
        guard let userId = userId,
            let userName = userName else {
                
                bail()
                return
        }
        
        logger.setUserIdentifier(userId)
        logger.setUserName(userName)
        Answers.logCustomEvent(withName: "SessionStart", customAttributes: ["userId":userId, "userName":userName])
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
