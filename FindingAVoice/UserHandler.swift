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
//import Firebase

/*
 Check if we have a local user. 
 
 If we do, tell Fabric about this session.
 
 If we don't, pop up the "Who are you anyway?" screen.
 */

class UserHandler {
    
    static let instance = UserHandler()
    private init() { }
    
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
    
    private var store: UserDefaults {
        return UserDefaults.standard
    }
    
    private var logger: Crashlytics {
        return Crashlytics.sharedInstance()
    }
    
    func handleSessionStart() {
        
        if hasLocalUser {
        
            setUpStoredLocalUser()
            
        } else {
            
            showSignupScreen()
        }
    }
    
    func logUserSignup(name: String, id: String) {
        
        userId = id
        userName = name
        
        Answers.logCustomEvent(withName: "UserSignup", customAttributes: ["userId": id, "userName": name])
    }
    
    private func setUpStoredLocalUser() {
        
        guard let userId = userId,
            let userName = userName else {
                
                bail()
                return
        }
        
        logger.setUserIdentifier(userId)
        logger.setUserName(userName)
        Answers.logCustomEvent(withName: "SessionStart", customAttributes: ["userId":userId, "userName":userName])
    }
    
    private func showSignupScreen() {
        
        presentViewController(SignupViewController())
    }
    
    private func bail() {
        
        let alert = UIAlertController(title: "Data error", message: "Something has gone wrong. Please delete and reinstall the app, or your data will not be recorded properly.", preferredStyle: .alert)
        
        presentViewController(alert)
    }
    
    private func presentViewController(_ viewController: UIViewController) {
        
        delay(1) {
            UIApplication.shared.keyWindow!.rootViewController!.present(viewController, animated: true, completion: nil)
        }
    }
}
