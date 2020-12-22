//
//  ServerCoordinator.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import SVProgressHUD

struct ServerCoordinator {
    
    static let shared = ServerCoordinator()
    
    private var auth: Auth!
    private let url = "https://finding-a-voice.firebaseio.com/"
//    private var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    private init() {
        
        FirebaseApp.configure()
        auth = Auth.auth()
    }
    
    func handleAppLaunch(email: String? = nil, password: String? = nil, completion: @escaping LoginCompletion) {
        
        if let email = email, let password = password {
            logIn(email: email, password: password, completion: completion)
        } else {
            completion(nil, nil)
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping LoginCompletion) {
        
        SVProgressHUD.show(withStatus: "Signing up…")
        
        auth.createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                // User exists already
                if error._code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    
                    self.logIn(email: email, password: password, completion: completion)
                    
                } else {
                    
                    SVProgressHUD.showError(withStatus: "Error creating user: \(error.localizedDescription)")
                    completion(result?.user, error)
                }
                
            } else {
                
                SVProgressHUD.showSuccess(withStatus: "Success!")
                completion(result?.user, error)
            }
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping LoginCompletion) {
        
        SVProgressHUD.show(withStatus: "Logging in…")
        
        auth.signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                
                // User doesn't exist
                if error._code == AuthErrorCode.userNotFound.rawValue {
                    
                    self.createUser(email: email, password: password, completion: completion)
                    
                } else {
                    
                    SVProgressHUD.showError(withStatus: "Error logging in: \(error.localizedDescription)")
                    completion(result?.user, error)
                }
                
            } else {
                
                SVProgressHUD.showSuccess(withStatus: "Logged in!")
                completion(result?.user, error)
            }
        }
    }

    func resetPassword(for email: String, completion: @escaping SendPasswordResetCallback) {
        auth.sendPasswordReset(withEmail: email, completion: completion)
    }
}
