//
//  ViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    var ruleSet: RuleSet!
    var length: Int!
    var currentQuestionIsValid: Bool = false
    
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var invalidButton: UIButton!
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var mainStringLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentQuestionIsValid = arc4random_uniform(2) == 0
        
        mainStringLabel.text = ruleSet.string(length: length, shouldBeValid: currentQuestionIsValid)
        
        var preceding = ruleSet.preceding
        var following = ruleSet.following
        
        var preceedingString = "\(preceding.popLast()!)"
        var followingString = "\(following.popLast()!)"
        
//        for (index, character) in preceding {
//            
//            if index == preceding.count - 1 {
//                preceedingString += " or \(character)"
//            } else {
//                preceedingString += ", \(character)"
//            }
//        }
//        
//        for (index, character) in following {
//            
//            if index == following.count - 1 {
//                followingString += " or \(character)"
//            } else {
//                followingString += ", \(character)"
//            }
//        }
        
        var text = "\(preceedingString) must be followed by \(followingString)"
        
        if ruleSet.stride > 1 {
            text += " \(ruleSet.stride) characters later"
        }
        
        text += "."
        
        ruleTextView.text = text
    }
    
    @IBAction func validButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
           print("Hooray")
        } else {
            print("Boo")
        }
    }
    
    @IBAction func invalidButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            print("Boo")
        } else {
            print("Hooray")
        }
    }
    
}

