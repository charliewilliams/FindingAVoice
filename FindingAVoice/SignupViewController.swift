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
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {

    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email.count > 3,
            let password = passwordTextField.text, password.count > 5 else {

                showAlert(text: "Email and password are both required")
                return
        }
        
        sender.isUserInteractionEnabled = false
        
        UserHandler.instance.createUser(email: email, password: password) { (user, error) in
            
            if user != nil {                
                delay(0.5) {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {

                self.showAlert(error: error)
            }
        }
    }

    func showAlert(text: String? = nil, error: Error? = nil) {

        let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default) { _ in
            self.confirmButton.isUserInteractionEnabled = true
        })

        self.present(alert, animated: true)
    }
}

extension SignupViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
