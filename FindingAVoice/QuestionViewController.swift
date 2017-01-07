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
    var stringLength: Int!
    var numberOfQuestionsPerRound: Int = 3
    var currentQuestionNumber: Int = 0
    var currentQuestionIsValid: Bool = false
    fileprivate var ruleTextViewYPosition: CGFloat = 0
    
    @IBOutlet weak var validButton: AnswerButton!
    @IBOutlet weak var invalidButton: AnswerButton!
    
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
            validButton.sparkle()
        } else {
            validButton.shake()
        }
        
        showNextQuestion()
    }
    
    @IBAction func invalidButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            invalidButton.shake()
        } else {
            invalidButton.sparkle()
        }
        
        showNextQuestion()
    }
}

private extension QuestionViewController {
    
    func showNextQuestion() {
        
        currentQuestionNumber += 1
        
        if currentQuestionNumber >= numberOfQuestionsPerRound {
            
            currentQuestionNumber = 0
            showNextRound()
            
        } else {
            
            _showNextQuestion()
        }
        
    }
    
    func _showNextQuestion() {
        
        animateQuestionOffscreen() {
            self.updateQuestionText()
            self.animateQuestionOnscreen()
        }
    }
    
    func showNextRound() {
        
        animateQuestionOffscreen() {
            self.animateRuleSetOffscreen() {
                
                delay(0.75) {
                    
                    self.buildNewRuleSet()
                    
                    self.animateRuleSetOnscreen() {
                        
                        self.updateQuestionText()
                        self.animateQuestionOnscreen()
                    }
                }
            }
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
        
        mainStringLabel.text = ruleSet.string(length: stringLength, shouldBeValid: currentQuestionIsValid)
        ruleTextView.text = ruleSet.userFacingDescription
    }
    
    func animateQuestionOnscreen() {
        
        mainStringLabel.frame.origin.x = view.bounds.width
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
            
            self.mainStringLabel.center.x = self.view.center.x
            
        }, completion: nil)
    }
    
    func animateRuleSetOffscreen(completion: @escaping Completion) {
        
        ruleTextViewYPosition = self.ruleTextView.frame.origin.y
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.ruleTextView.frame.origin.y = -self.ruleTextView.frame.size.height
            
        }, completion: { _ in
            
            completion()
        })
    }
    
    func buildNewRuleSet() {
        
        ruleSet = RuleSet(precedingCount: ruleSet.preceding.count, followingCount: ruleSet.following.count, vocabulary: ruleSet.vocabulary, stride: ruleSet.stride)
        ruleTextView.text = ruleSet.userFacingDescription
    }
    
    func animateRuleSetOnscreen(completion: @escaping Completion) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.ruleTextView.frame.origin.y = self.ruleTextViewYPosition
            
        }, completion: { _ in
            
            completion()
        })
    }
}

