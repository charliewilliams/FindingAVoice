//
//  LockScreenDisplaying.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

protocol LockScreenDisplaying {
    
    var timeExceededForToday: Bool { get set }
    
    func showTimeExceededLockScreen()
}

extension LockScreenDisplaying where Self: UIViewController {
    
    func showTimeExceededLockScreen() {
        present(TimesUpLockViewController(), animated: true, completion: nil)
    }
}
