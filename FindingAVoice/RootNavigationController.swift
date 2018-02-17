//
//  RootNavigationController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    private var overlayVC: AnalyticsDebugOverlayTableViewController = {
        let vc = AnalyticsDebugOverlayTableViewController()
        AnalyticsDebugOverlayTableViewController.instance = vc // bad, yeah
        return vc
    }()

    var button: UIButton = {

        let button = UIButton(type: .custom)
        button.setTitle("DEBUG ANALYTICS", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.red, for: .normal)
        button.frame = CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: 120, height: 44))
        button.addTarget(self, action: #selector(toggleDebugOverlay), for: .touchUpInside)

        button.isHidden = true

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // WARNING don't release with this button visible!
        view.addSubview(button)

        viewControllers = [WelcomeViewController(nibName: nil, bundle: nil)]

        let secretTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(secretDebugTap))
        secretTapRecognizer.numberOfTapsRequired = 2
        secretTapRecognizer.numberOfTouchesRequired = 4

        view.addGestureRecognizer(secretTapRecognizer)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        setNavigationBarHidden(true, animated: true)
        return super.popViewController(animated: animated)
    }

    @objc private func toggleDebugOverlay() {

        guard let topVC = topViewController else {
            dismiss(animated: true, completion: nil)
            return
        }

        overlayVC.view.frame = topVC.view.bounds

        if topVC == overlayVC {
            _ = popViewController(animated: true)
            setNavigationBarHidden(true, animated: true)

        } else {
            pushViewController(overlayVC, animated: true)
            setNavigationBarHidden(false, animated: true)
        }
    }

    @objc private func secretDebugTap(_ sender: UIGestureRecognizer) {

        button.isHidden = !button.isHidden
    }
}
