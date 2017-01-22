//
//  PopoverDisplaying.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 14/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

enum PopoverType {
    case perQuestionTimeout
    case singingDetected
}

protocol PopoverDisplaying: class {
    func showPopover(type: PopoverType)
}

extension PopoverDisplaying where Self: UIViewController {
    
    func showPopover(type: PopoverType) {
        
        
    }
}
