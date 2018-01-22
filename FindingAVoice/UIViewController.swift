//
//  UIViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2018.
//  Copyright © 2018 Charlie Williams. All rights reserved.
//

import UIKit

protocol ProgressHosting {
    weak var progressContainerView: UIView! { get }
}

extension ProgressHosting where Self: UIViewController {

    func addProgress() {

        loadViewIfNeeded()
        
        let progressVC = ProgressViewController(nibName: nil, bundle: nil)
        progressContainerView.addSubview(progressVC.view)
        progressVC.view.frame = progressContainerView.bounds
        progressVC.setUp(in: progressContainerView)
        addChildViewController(progressVC)
        progressVC.didMove(toParentViewController: self)
    }

    func updateProgress() {

        if let progressVC = childViewControllers.filter({ $0 is ProgressViewController }).first as? ProgressViewController {
            progressVC.updateProgress()
        }
    }
}
