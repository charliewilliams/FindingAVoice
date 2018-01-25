//
//  WelcomeViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!

    var isPractice: Bool = false {
        didSet {
            if isPractice {
                loadViewIfNeeded()
                getStartedButton.setTitle("Let's practice", for: .normal)
            }
        }
    }
    var isImmediatelyPostPractice: Bool = false {
        didSet {
            if isImmediatelyPostPractice {
                loadViewIfNeeded()
                welcomeLabel.text = "Great! Let's play for real."
                mainTitleLabel.text = "As a review, the rules are:"
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: "ExperimentalWelcomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        present(InfoViewController(), animated: true, completion: nil)
    }
    

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        
        guard let navigationController = navigationController else {
            assertionFailure()
            return
        }
        
        let questionVC = ExperimentalQuestionViewController(forPractice: isPractice)
        
        // When to show the music player vs the questions
        if MusicPlayerContainerViewController.userHasAnsweredAllSongs {
            
            navigationController.pushViewController(questionVC, animated: true)
            
        } else {
            
            navigationController.pushViewController(questionVC, animated: false)
            
            let musicPlayerVC = UIStoryboard(name: "SnippetPlayer", bundle: nil).instantiateInitialViewController()!
            navigationController.pushViewController(musicPlayerVC, animated: true)
        }
    }
}

extension WelcomeViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
