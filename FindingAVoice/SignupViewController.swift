//
//  SignupViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 19/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {

    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email.characters.count > 3 else {
            return
        }
        
        sender.isUserInteractionEnabled = false
        
        UserHandler.instance.createUser(email: email) { (user, error) in
            
            if user != nil {                
                delay(0.5) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension SignupViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
