//
//  ViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, QuestionTiming, PopoverDisplaying, LockScreenDisplaying {
    
    var ruleSet: RuleSet! {
        didSet {
            if isViewLoaded {
                updateQuestionText()
            }
        }
    }
    var difficulty = DifficultyProvider.currentDifficulty
    var stringLength: Int! {
        switch difficulty {
        case .easy: return 10
        case .medium: return 15
        case .hard: return 20
        }
    }
    var numberOfQuestionsPerRound: Int = 3
    var delayTimeBeforeShowingQuestion: TimeInterval = 5
    var delayTimeBetweenQuestions: TimeInterval = 1
    var currentQuestionNumber: Int = 0
    var currentQuestionIsValid: Bool = false
    fileprivate var ruleLabelYPosition: CGFloat = 0
    let perQuestionTimer = QuestionTimer.shared
    let dailyTimer = DailyTimer.shared
    var timeExceededForToday: Bool = false
    
    @IBOutlet weak var validButton: AnswerButton!
    @IBOutlet weak var invalidButton: AnswerButton!
    
    @IBOutlet weak var ruleLabel: UILabel!
    @IBOutlet weak var ruleLabelContainerView: UIView!
    
    @IBOutlet weak var mainStringLabel: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perQuestionTimer.delegate = self
        
        // Hide the question at the start so that you can read the rule first
        mainStringLabel.alpha = 0
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: delayTimeBeforeShowingQuestion, options: [], animations: { 
            self.mainStringLabel.alpha = 1
        }, completion: nil)
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
            ruleLabel.text = ruleSet.userFacingDescription
            
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
        
        ruleLabelYPosition = self.ruleLabelContainerView.frame.origin.y
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.ruleLabelContainerView.frame.origin.y = -self.ruleLabelContainerView.frame.size.height
            
        }, completion: { _ in
            
            completion()
        })
    }
    
    func buildNewRuleSet() {
        
        ruleSet = ruleSet.similarCopy()
        ruleLabel.text = ruleSet.userFacingDescription
    }
    
    func animateRuleSetOnscreen(completion: @escaping Completion) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.ruleLabelContainerView.frame.origin.y = self.ruleLabelYPosition
            
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

extension QuestionViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}

