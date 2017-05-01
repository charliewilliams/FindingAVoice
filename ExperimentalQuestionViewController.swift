//
//  ExperimentalQuestionViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class ExperimentalQuestionViewController: UIViewController {

    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songLyricsLabel: UILabel!
    @IBOutlet weak var questionFirstHalfLabel: UILabel!
    @IBOutlet weak var questionSecondHalfLabel: UILabel!
    @IBOutlet weak var higherButton: AnswerButton!
    @IBOutlet weak var sameButton: AnswerButton!
    @IBOutlet weak var lowerButton: AnswerButton!
    var buttons: [AnswerButton] {
        return [higherButton, sameButton, lowerButton]
    }
    
    var question: Question! {
        didSet {
            if isViewLoaded {
                setup(withQuestion: question)
            }
        }
    }
    
    let highlightedAttributesBig: [String: Any] = [
        NSBackgroundColorAttributeName: UIColor.yellow,
        NSForegroundColorAttributeName: UIColor.blue,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
        NSFontAttributeName: UIFont.italicSystemFont(ofSize: 36)
    ]
    
    let highlightedAttributesSmall: [String: Any] = [
        NSBackgroundColorAttributeName: UIColor.yellow,
        NSForegroundColorAttributeName: UIColor.blue,
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
        NSFontAttributeName: UIFont.italicSystemFont(ofSize: 18)
    ]
    
//    let regularAttributes: [String: Any] = [
//        NSBackgroundColorAttributeName: UIColor.white,
//        NSForegroundColorAttributeName: UIColor.darkGray,
//        NSFontAttributeName: UIFont.systemFont(ofSize: 30)
//    ]
    
    var firstText: NSAttributedString {
        
        let mutable = NSMutableAttributedString(string: "Is the syllable \(question.secondHighlight)")
        mutable.addAttributes(highlightedAttributesBig, range: NSRange(location: 16, length: question.secondHighlight.characters.count))
        
        return mutable
    }
    
    var secondText: NSAttributedString {
        
        let mutable = NSMutableAttributedString(string: "than \(question.firstHighlight)?")
        mutable.addAttributes(highlightedAttributesBig, range: NSRange(location: 5, length: question.firstHighlight.characters.count))
        
        return mutable
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        loadViewIfNeeded()
        self.question = QuestionProvider.shared.nextQuestion()
        setup(withQuestion: question)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(withQuestion question: Question) {
        
        songTitleLabel.text = "In the song \"\(question.song.title)\""
        
        //question.song.lyrics.replacingOccurrences(of: "-", with: "")
        let displayLyrics = "(\"\(question.song.lyrics)\")"
        let mutable = NSMutableAttributedString(string: displayLyrics)
        
        // Find the highlighted bit AS A WHOLE SYLLABLE
        let range1a = (displayLyrics as NSString).range(of: question.firstHighlight + " ")
        let range2a = (displayLyrics as NSString).range(of: question.secondHighlight + " ")
        let range1b = (displayLyrics as NSString).range(of: question.firstHighlight + "-")
        let range2b = (displayLyrics as NSString).range(of: question.secondHighlight + "-")
        
        var range1 = range1a.location != NSNotFound ? range1a : range1b
        var range2 = range2a.location != NSNotFound ? range2a : range2b
        range1.length -= 1 // remove the space or dash
        range2.length -= 1 // remove the space or dash
        
        mutable.addAttributes(highlightedAttributesSmall, range: range1)
        mutable.addAttributes(highlightedAttributesSmall, range: range2)
        
        songLyricsLabel.attributedText = mutable
        questionFirstHalfLabel.attributedText = firstText
        questionSecondHalfLabel.attributedText = secondText
        
        delay(1) {
            self.buttons.forEach { $0.isEnabled = true }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        guard let button = sender as? AnswerButton,
            let rawAnswer = sender.titleLabel?.text?.characters.first,
            let givenAnswer = Answer(rawValue: "\(rawAnswer)") else {
                fatalError("Something went wrong")
        }
        
        self.buttons.forEach { $0.isEnabled = false }
        
        if givenAnswer == question.answer {
            
            print("Hooray")
            button.sparkle()
            
        } else {
            
            print("Boo")
            button.shake()
        }
        
        delay(2) {
            self.question = QuestionProvider.shared.nextQuestion()
        }
    }
    
}