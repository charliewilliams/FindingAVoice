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
        
        // TODO logic around when to show the music player vs the questions
        
//        let musicPlayerVC = UIStoryboard(name: "SnippetPlayer", bundle: nil).instantiateInitialViewController()!
//        navigationController?.pushViewController(musicPlayerVC, animated: true)
        
        let questionVC = ExperimentalQuestionViewController()
        navigationController?.pushViewController(questionVC, animated: true)
    }

}
