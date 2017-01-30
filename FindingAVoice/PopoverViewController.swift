//
//  PopoverViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    weak var delegate: PopoverDisplaying?
    @IBOutlet weak var popoverView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popoverBottomToScreenBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var continueButton: UIButton!
    
    var requiresInteractionToDismiss: Bool = true {
        didSet {
            continueButton.isHidden = !requiresInteractionToDismiss
        }
    }
    
    init(type: PopoverType) {
        
        super.init(nibName: nil, bundle: nil)
        
        
        
        //UIAlertController(title: "Timed out", message: "Looks like that was a hard one", preferredStyle: .actionSheet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.popoverBottomToScreenBottomConstraint.constant = -self.popoverView.bounds.height
        self.view.layoutIfNeeded()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent != nil {
            animate(in: true)
        }
    }

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        animate(in: false)
    }
}

private extension PopoverViewController {
    
    func animate(in animatingIn: Bool) {
        
        if animatingIn {
            
            animateBackgroundView(toVisible: true) {
                self.animatePopoverView(toVisible: true)
            }
            
        } else {
            
            animatePopoverView(toVisible: false) {
                self.animateBackgroundView(toVisible: false)
            }
        }
    }
    
    func animatePopoverView(toVisible: Bool, completion: Completion? = nil) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.popoverBottomToScreenBottomConstraint.constant = toVisible ? 0 : -self.popoverView.bounds.height
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            if let completion = completion {
                completion()
            }
        })
    }
    
    func animateBackgroundView(toVisible: Bool, completion: Completion? = nil) {
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.backgroundView.alpha = toVisible ? 1 : 0
            
        }, completion: { _ in
            
            if let completion = completion {
                completion()
            }
            if !toVisible {
                self.cleanUp()
            }
        })
    }
    
    func cleanUp() {
        
        delegate?.popoverWillDismiss()
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
        didMove(toParentViewController: nil)
    }
}
