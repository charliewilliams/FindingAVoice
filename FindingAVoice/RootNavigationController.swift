//
//  RootNavigationController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [WelcomeViewController(nibName: nil, bundle: nil)]
    }
}
