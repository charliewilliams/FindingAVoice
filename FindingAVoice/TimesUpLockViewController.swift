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

        // TODO poll periodically to see if it's tomorrow yet, in which case we dismiss
    }
    
    @IBAction func secretBypassGestureDetected(_ sender: UITapGestureRecognizer) {
        
        DailyTimer.shared.disabled = true
        DailyTimer.shared.pause()
        dismiss(animated: true, completion: nil)
    }
    
    // TODO - remove this before release
    @IBAction func debugBypassButtonPressed(_ sender: UIButton) {
        
        DailyTimer.shared.disabled = true
        DailyTimer.shared.pause()
        dismiss(animated: true, completion: nil)
    }
}

extension TimesUpLockViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
