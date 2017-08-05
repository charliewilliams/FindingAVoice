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
        
        // Todo figure out when to set isPractice to false
        
        let questionVC = ExperimentalQuestionViewController(forPractice: true)
        
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
