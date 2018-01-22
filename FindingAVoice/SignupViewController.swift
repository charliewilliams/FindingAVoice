//
//  SignupViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 19/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

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

    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {

        let alert = UIAlertController(title: "Reset Password", message: "Enter your email to receive a password reset link", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter email"
            textField.text = self.emailTextField.text
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })

        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in

            guard let email = alert.textFields?[0].text else {
                self?.showAlert(text: "You must enter an email to reset your password", error: nil)
                return
            }

            ServerCoordinator.shared.resetPassword(for: email) { error in

                if let error = error {
                    self?.showAlert(text: "Error", error: error)
                } else {
                    self?.showAlert(title: "Done!", text: "Password reset email sent, go check your email.", error: nil, buttonText: "OK")
                }
            }
        })

        present(alert, animated: true)
    }


    func showAlert(title: String = "Error", text: String? = nil, error: Error? = nil, buttonText: String = "Try again") {

        let alert = UIAlertController(title: title, message: error?.localizedDescription ?? text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default) { _ in
            self.confirmButton.isUserInteractionEnabled = true
        })

        present(alert, animated: true)
    }
}

extension SignupViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
