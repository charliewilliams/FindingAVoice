//
//  ViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

typealias Completion = () -> ()

class QuestionViewController: UIViewController, QuestionTiming, PopoverDisplaying, LockScreenDisplaying {
    
    var ruleSet: RuleSet! {
        didSet {
            if isViewLoaded {
                updateQuestionText()
            }
        }
    }
    var stringLength: Int!
    var numberOfQuestionsPerRound: Int = 3
    var delayTimeBeforeShowingQuestion: TimeInterval = 2
    var delayTimeBetweenQuestions: TimeInterval = 1
    var currentQuestionNumber: Int = 0
    var currentQuestionIsValid: Bool = false
    fileprivate var ruleTextViewYPosition: CGFloat = 0
    let perQuestionTimer = QuestionTimer.shared
    let dailyTimer = DailyTimer.shared
    var timeExceededForToday: Bool = false
    
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
            perQuestionTimer.reset()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dailyPlayTimeExceeded), name: Notification.Name(.dailySessionTimeExceeded), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func validButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            validButton.sparkle()
        } else {
            validButton.shake()
        }
        
        handleAnyButtonPress()
    }
    
    @IBAction func invalidButtonPressed(_ sender: UIButton) {
        
        if currentQuestionIsValid {
            invalidButton.shake()
        } else {
            invalidButton.sparkle()
        }
        
        handleAnyButtonPress()
    }
    
    func popoverWillDismiss() {
        showNextQuestionOrRound()
    }
}

private extension QuestionViewController {
    
    func handleAnyButtonPress() {
        
        perQuestionTimer.clear()
        setButtons(enabled: false)
        
        delay(delayTimeBetweenQuestions) {
            self.showNextQuestionOrRound()
        }
    }
    
    func setButtons(enabled: Bool) {
        
        invalidButton.isUserInteractionEnabled = enabled
        validButton.isUserInteractionEnabled = enabled
    }
    
    func showNextQuestionOrRound() {
        
        guard timeExceededForToday == false else {
            
            showTimeExceededLockScreen()
            return
        }
        
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
                        
                        delay(self.delayTimeBeforeShowingQuestion) {
                            self.updateQuestionText()
                            self.animateQuestionOnscreen()
                        }
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
        
        do {
            
            mainStringLabel.text = try ruleSet.string(length: stringLength, shouldBeValid: currentQuestionIsValid)
            ruleTextView.text = ruleSet.userFacingDescription
            
        } catch let e {
            
            let alertController = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func animateQuestionOnscreen() {
        
        mainStringLabel.frame.origin.x = view.bounds.width
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
            
            self.mainStringLabel.center.x = self.view.center.x
            
        }, completion: { _ in
        
            self.setButtons(enabled: true)
            self.perQuestionTimer.reset()
        })
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
        
        setButtons(enabled: false)
        showPopover(type: .perQuestionTimeout)
    }
    
    func dailyPlayTimeExceeded() {
        timeExceededForToday = true
    }
}

