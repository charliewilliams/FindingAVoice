//
//  ProgressViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2018.
//  Copyright © 2018 Charlie Williams. All rights reserved.
//

import UIKit
import YLProgressBar

class ProgressViewController: UIViewController {

    var progress: CGFloat {
        get {
            return progressBar.progress
        }
        set {
            progressBar.progress = newValue
        }
    }
    let progressBar: YLProgressBar = {

        let bar = YLProgressBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.type = .flat
        bar.hideStripes = false
        bar.hideGloss = false
        bar.progressStretch = false
        bar.stripesAnimationVelocity = 0.05
        bar.progressTintColors = [
            UIColor(red:  33/255.0, green: 180/255.0, blue: 162/255.0, alpha: 1),
            UIColor(red:   3/255.0, green: 137/255.0, blue: 166/255.0, alpha: 1),
            UIColor(red:  91/255.0, green:  63/255.0, blue: 150/255.0, alpha: 1),
            UIColor(red:  87/255.0, green:  26/255.0, blue:  70/255.0, alpha: 1),
            UIColor(red: 126/255.0, green:  26/255.0, blue:  36/255.0, alpha: 1),
            UIColor(red: 149/255.0, green:  37/255.0, blue:  36/255.0, alpha: 1),
            UIColor(red: 228/255.0, green:  69/255.0, blue:  39/255.0, alpha: 1),
            UIColor(red: 245/255.0, green: 166/255.0, blue:  35/255.0, alpha: 1),
            UIColor(red: 165/255.0, green: 202/255.0, blue:  60/255.0, alpha: 1),
            UIColor(red: 202/255.0, green: 217/255.0, blue:  54/255.0, alpha: 1),
            UIColor(red: 111/255.0, green: 188/255.0, blue:  84/255.0, alpha: 1)
        ]

        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(progressBar)

        let views = ["progress": progressBar]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progress]|", options: [], metrics: [:], views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progress]|", options: [], metrics: [:], views: views))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateProgress()
    }

    func updateProgress() {
        progress = CGFloat(DailyTimer.shared.previouslyStoredPlayTimeFromToday / DailyTimer.shared.dailyPlayTime)
    }

    func setUp(in container: UIView) {

        loadViewIfNeeded()
        let views = ["view": view!]
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: [:], views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: [:], views: views))
    }
}
