//
//  TimesUpLockViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class TimesUpLockViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO poll periodically to see if it's tomorrow yet
    }
    
    @IBAction func secretBypassGestureDetected(_ sender: UITapGestureRecognizer) {
        
        DailyTimer.shared.disabled = true
        DailyTimer.shared.pause()
        dismiss(animated: true, completion: nil)
    }
    
}
