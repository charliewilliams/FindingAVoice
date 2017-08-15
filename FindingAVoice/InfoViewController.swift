//
//  InfoViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension InfoViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
