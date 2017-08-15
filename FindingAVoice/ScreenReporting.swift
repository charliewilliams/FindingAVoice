//
//  ScreenReporting.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 15/08/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

protocol ScreenReporting {
    var screenName: String { get }
    func didViewScreen()
}

extension ScreenReporting where Self: UIViewController {
    
    var screenName: String {
        return String(describing: self)
    }
    
    func didViewScreen() {
        Analytics.logScreen(named: screenName)
    }
}
