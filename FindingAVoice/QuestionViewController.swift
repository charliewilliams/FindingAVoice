//
//  ViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

typealias Completion = () -> ()

class QuestionViewController: UIViewController, QuestionTiming {
    
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
    let perQuestionTimer = QuestionTimer.shared
    let dailyTimer = DailyTimer.shared
    
    @IBOutlet weak var validButton: AnswerButton!
    @IBOutlet weak var invalidButton: AnswerButton!
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var mainStringLabel: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perQuestionTimer.delegate = self
        
        if ruleSet != nil {
            updateQuestionText()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dailyPlayTimeExceeded), name: Notification.Name(.dailySessionTimeExceeded), object: nil)
    }

    @IBAction func validButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            validButton.sparkle()
        } else {
            validButton.shake()
        }
        
        delay(5) {
            self.showNextQuestion()
        }
    }
    
    @IBAction func invalidButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            invalidButton.shake()
        } else {
            invalidButton.sparkle()
        }
        
        delay(5) {
            self.showNextQuestion()
        }
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
        
        perQuestionTimer.reset()
        
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
        
        ruleSet = ruleSet.similarCopy()
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

// MARK: - Timeouts

extension QuestionViewController {
    
    func questionDidTimeOut() {
        
        view.backgroundColor = .red
    }
    
    func dailyPlayTimeExceeded() {
        
        view.backgroundColor = .orange
    }
}

