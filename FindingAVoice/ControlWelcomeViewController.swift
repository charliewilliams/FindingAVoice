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
    var isPractice: Bool = false

    var isImmediatelyPostPractice: Bool = false {
        didSet {
            if isImmediatelyPostPractice {
                loadViewIfNeeded()
                welcomeLabel.text = "Great! Let's play for real."
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: "ControlWelcomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        present(InfoViewController(), animated: true, completion: nil)
    }
    

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        
//        navigationController?.pushViewController(SecretSetupViewController(), animated: true)

        navigationController?.pushViewController(QuestionViewController(forPractice: isPractice), animated: true)
    }

}

extension WelcomeViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
