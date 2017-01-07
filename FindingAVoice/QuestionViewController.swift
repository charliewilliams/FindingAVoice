//
//  ViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

typealias Completion = () -> ()

class QuestionViewController: UIViewController {
    
    var ruleSet: RuleSet! {
        didSet {
            if isViewLoaded {
                updateQuestionText()
            }
        }
    }
    var length: Int!
    var currentQuestionIsValid: Bool = false
    
    @IBOutlet weak var validButton: UIButton!
    @IBOutlet weak var invalidButton: UIButton!
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var mainStringLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ruleSet != nil {
            updateQuestionText()
        }
    }

    @IBAction func validButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            print("Hooray")
        } else {
            print("Boo")
        }
        
        showNextQuestion()
    }
    
    @IBAction func invalidButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            print("Boo")
        } else {
            print("Hooray")
        }
        
        showNextQuestion()
    }
}

private extension QuestionViewController {
    
    func showNextQuestion() {
        
        animateQuestionOffscreen() {
            
            self.updateQuestionText()
            self.animateQuestionOnscreen()
        }
    }
    
    func animateQuestionOffscreen(completion: @escaping Completion) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            
            self.mainStringLabel.center.x = -self.view.bounds.width
            
        }, completion: { finished in
            
            completion()
        })
    }
    
    func updateQuestionText() {
        
        currentQuestionIsValid = arc4random_uniform(2) == 0
        
        mainStringLabel.text = ruleSet.string(length: length, shouldBeValid: currentQuestionIsValid)
        ruleTextView.text = ruleSet.userFacingDescription
    }
    
    func animateQuestionOnscreen() {
        
        mainStringLabel.frame.origin.x = view.bounds.width
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
            
            self.mainStringLabel.center.x = self.view.center.x
            
        }, completion: nil)
    }
}

