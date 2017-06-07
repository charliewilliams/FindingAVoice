//
//  SingingDetectable.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 07/06/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit


protocol SingingDetectable {
    var childSingingDetectorViewController: SingingDetectorViewController! { get }
}

extension SingingDetectable where Self: UIViewController {
    
}
