//
//  SignupViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 19/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import SVProgressHUD

let userIdLength = 5

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var userIDTextField: UITextField!
    
    @IBAction func textFieldDidEndEditing(_ sender: UITextField) {
        
        if sender == nameTextField {
            userIDTextField.becomeFirstResponder()
        } else if nameTextField.text == nil || nameTextField.text!.isValidName == false {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        
        guard let userId = userIDTextField.text, userId.characters.count == userIdLength,
            let userName = nameTextField.text, userName.isValidName else {
                return
        }
        
        sender.isUserInteractionEnabled = false
        
        UserHandler.instance.createUser(name: userName, id: userId) {
            
            delay(0.5) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
