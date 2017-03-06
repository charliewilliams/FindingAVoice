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
    

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        present(InfoViewController(), animated: true, completion: nil)
    }
    

    @IBAction func getStartedButtonPressed(_ sender: UIButton) {
        
        navigationController?.pushViewController(InitialSongRecognitionViewController(), animated: true)
    }

}
