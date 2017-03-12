//
//  ServerCoordinator.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

struct ServerCoordinator {
    
    static let shared = ServerCoordinator()
    
    private var auth: FIRAuth!
    private let url = "https://finding-a-voice.firebaseio.com/"
//    private var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    private init() {
        
        FIRApp.configure()
        auth = FIRAuth.auth()
    }
    
    func handleAppLaunch(username: String? = nil, password: String? = nil, completion: @escaping LoginCompletion) {
        
        if let username = username, let password = password {
            logIn(id: username, password: password, completion: completion)
        } else {
            completion(nil, nil)
        }
    }
    
    func createUser(id: String, name: String, password: String, completion: Completion) {
        
        SVProgressHUD.show(withStatus: "Signing up…")
        
        auth.createUser(withEmail: id, password: password) { (user, error) in
            
            if let error = error {
                SVProgressHUD.showError(withStatus: "Error creating user: \(error.localizedDescription)")
            } else {
                SVProgressHUD.showSuccess(withStatus: "Success!")
            }
        }
    }
    
    func logIn(id: String, password: String, completion: @escaping LoginCompletion) {
        
        SVProgressHUD.show(withStatus: "Logging in…")
        
        auth.signIn(withEmail: id, password: password, completion: { (user, error) in
            
            if let error = error {
                SVProgressHUD.showError(withStatus: "Error logging in: \(error.localizedDescription)")
            } else {
                SVProgressHUD.showSuccess(withStatus: "Logged in!")
            }
            
            completion(user, error)
        })
    }
}
