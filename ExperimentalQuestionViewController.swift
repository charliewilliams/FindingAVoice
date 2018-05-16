//
//  ExperimentalQuestionViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class ExperimentalQuestionViewController: UIViewController, SingingDetectable, QuestionTiming, PopoverDisplaying, LockScreenDisplaying, ProgressHosting {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songLyricsLabel: UILabel!
    @IBOutlet weak var questionFirstHalfLabel: UILabel!
    @IBOutlet weak var questionSecondHalfLabel: UILabel!
    @IBOutlet weak var higherButton: AnswerButton!
    @IBOutlet weak var sameButton: AnswerButton!
    @IBOutlet weak var lowerButton: AnswerButton!
    @IBOutlet weak var containerViewCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var answersSectionStackView: UIStackView!
    @IBOutlet weak var practiceHelperWordsStackView: UIStackView!
    @IBOutlet weak var progressContainerView: UIView!
    
    var buttons: [AnswerButton] {
        return [higherButton, sameButton, lowerButton]
    }
    var childSingingDetectorViewController: SingingDetectorViewController!
    
    // Protocol conformance
    let perQuestionTimer = QuestionTimer.shared
    let dailyTimer = DailyTimer.shared
    var timeExceededForToday = false
    
    var question: Question! {
        didSet {
            if isViewLoaded {
                setup(withQuestion: question)
            }
        }
    }

    let numberOfPracticeRounds = 3
    var practiceRoundNumber: Int = 0
    var isPractice: Bool = false {
        didSet {
            if !isPractice {
                answersSectionStackView.removeArrangedSubview(practiceHelperWordsStackView)
            }
        }
    }
    
    let highlightedAttributesBigRed: [NSAttributedStringKey: Any] = [
        .backgroundColor: UIColor.clear,
        .foregroundColor: UIColor.red,
        .font: UIFont.systemFont(ofSize: 36)
    ]

    var firstText: NSAttributedString {
        
        let string = isPractice ? "Is \(question.secondHighlight)" : question.secondHighlight
        let mutable = NSMutableAttributedString(string: string)
        let location = isPractice ? 3 : 0
        mutable.setAttributes([.foregroundColor: UIColor.black], range: NSRange(location: 0, length: string.count))
        mutable.addAttributes(highlightedAttributesBigRed, range: NSRange(location: location, length: question.secondHighlight.count))
        
        return mutable
    }
    
    var secondText: NSAttributedString {
        
        let string = isPractice ? "\(question.firstHighlight) ?" : question.firstHighlight
        let mutable = NSMutableAttributedString(string: string)
        mutable.setAttributes([.foregroundColor: UIColor.black], range: NSRange(location: 0, length: string.count))
        mutable.addAttributes(highlightedAttributesBigRed, range: NSRange(location: 0, length: question.firstHighlight.count))
        
        return mutable
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(forPractice isPractice: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        loadViewIfNeeded()
        
        self.isPractice = isPractice
        
        childSingingDetectorViewController = UIStoryboard(name: "SingingDetector", bundle: nil).instantiateInitialViewController() as! SingingDetectorViewController
        childSingingDetectorViewController.willMove(toParentViewController: self)
        addChildViewController(childSingingDetectorViewController)
        childSingingDetectorViewController.view.frame = view.bounds
        view.addSubview(childSingingDetectorViewController.view)
        childSingingDetectorViewController.didMove(toParentViewController: self)
        
        question = QuestionProvider.shared.nextQuestion()
        setup(withQuestion: question)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        perQuestionTimer.delegate = self
        perQuestionTimer.reset()
        
        for button in buttons {
            button.layer.borderColor = UIColor.blue.cgColor
            button.layer.borderWidth = 2
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(dailyPlayTimeExceeded), name: Notification.Name(.dailySessionTimeExceeded), object: nil)

        addProgress()
    }
    
    func setButtons(enabled: Bool) {
        
        self.buttons.forEach { $0.isEnabled = enabled }
    }
    
    private func setup(withQuestion question: Question) {

        Analytics.clearEvent()

        // We need to log the start here so that the first question has a latency, even though it doesn't animate onscreen.
        Analytics.logStartOfEvent(value: self.question.song.id)

        UIView.performWithoutAnimation {
            containerViewCenterXConstraint.constant = view.bounds.width
            view.layoutIfNeeded()   
        }
        
        songTitleLabel.text = question.song.title

        songLyricsLabel.attributedText = question.song.attributedText(for: question)
        questionFirstHalfLabel.attributedText = firstText
        questionSecondHalfLabel.attributedText = secondText
        
        UIView.animate(withDuration: 0.3, animations: { 
            
            self.containerViewCenterXConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
        
            delay(1) {
                self.setButtons(enabled: true)
            }
        })
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        guard let button = sender as? AnswerButton,
            let rawAnswer = sender.titleLabel?.text?.first,
            let givenAnswer = Answer(rawValue: "\(rawAnswer)") else {
                assert(false, "Something went wrong")
                return
        }
        
        setButtons(enabled: false)
        if isPractice {
            practiceRoundNumber += 1
        }
        perQuestionTimer.clear()
        
        if givenAnswer == question.answer {
            
            print("Hooray")
            log(correct: true, answer: givenAnswer.rawValue)
            button.sparkle()
            
        } else {
            
            print("Boo")
            log(correct: false, answer: givenAnswer.rawValue, correctAnswer: question.answer.rawValue)
            button.shake()
        }
        
        delay(1.5) { [weak self] in
            
            self?.showNextQuestionOrRound()
        }
    }
    
    private func showNextQuestionOrRound() {

        updateProgress()
        
        guard timeExceededForToday == false else {
            
            showTimeExceededLockScreen()
            return
        }

        if isPractice && practiceRoundNumber > numberOfPracticeRounds {

            let welcomeVC = WelcomeViewController(nibName: nil, bundle: nil)
            welcomeVC.isImmediatelyPostPractice = true
            navigationController?.setViewControllers([welcomeVC], animated: false)

        } else {

            _showNextQuestion()
        }
    }
    
    private func _showNextQuestion() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.containerViewCenterXConstraint.constant = -self.view.bounds.width
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            delay(0.5) {
                self.question = QuestionProvider.shared.nextQuestion()
                self.perQuestionTimer.reset()
                Analytics.logStartOfEvent(value: self.question.song.id)
            }
        })
    }
    
    private func log(correct: Bool, answer: String, correctAnswer: String? = nil) {
        
        let knowledgeLevel = "\(question.song.knowledgeLevel!.rawValue)"

        var data = [
            "first": question.firstHighlight,
            "second": question.secondHighlight,
            "knowledgeLevel": knowledgeLevel,
            "difficulty": question.difficulty.rawValue
        ]

        if let correctAnswer = correctAnswer {
            data["correctAnswer"] = correctAnswer
        }

        Analytics.log(eventName: "response", eventValue: question.song.id, responseName: "response", responseValue: answer, wasCorrect: correct, duration: perQuestionTimer.secondsElapsed, data: data)
    }
    
    @objc func popoverWillDismiss() {
        showNextQuestionOrRound()
    }
}

// MARK: - Timeouts

extension ExperimentalQuestionViewController {
    
    @objc func questionDidTimeOut() {
        
        setButtons(enabled: false)
        showPopover(type: .perQuestionTimeout)

        let knowledgeLevel = "\(question.song.knowledgeLevel?.rawValue ?? 0)"
        Analytics.log(eventName: "no-response", eventValue: question.song.id, responseName: "timed-out", duration: perQuestionTimer.secondsElapsed, data: [
            "first": question.firstHighlight,
            "second": question.secondHighlight,
            "knowledgeLevel": knowledgeLevel,
            "difficulty": question.difficulty.rawValue
        ])
    }
    
    @objc func dailyPlayTimeExceeded() {
        timeExceededForToday = true
    }
}


extension ExperimentalQuestionViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setButtons(enabled: true)
        
        didViewScreen()
    }
}
