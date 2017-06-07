//
//  ViewController.swift
//  SingingDetectionDemo
//
//  Created by Charlie Williams on 04/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import AudioKit

class SingingDetectorViewController: UIViewController {
    
    @IBOutlet weak var detectionLabel: UILabel!
    
    let detector = SingingDetector.shared
    @IBOutlet var audioInputPlot: EZAudioPlot!
    var plotSubview: AKNodeOutputPlot!
    
    @IBOutlet weak var detectionView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var bottomToBottomSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlot()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.started.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.pitchChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.stopped.rawValue), object: nil)
        
        
        overlayView.alpha = 0
        bottomToBottomSpacingConstraint.constant = -detectionView.bounds.height
        view.layoutIfNeeded()
        view.isUserInteractionEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        plotSubview.frame = audioInputPlot.bounds
        bottomToBottomSpacingConstraint.constant = -self.detectionView.bounds.height
        view.layoutIfNeeded()
    }
    
    func gotNotification(note: Notification) {
        
        if let state = SingingState(rawValue: note.name.rawValue),
            state == .started {
            
            // Show the view
            animateDetectionView(hidden: false)
        }
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        animateDetectionView(hidden: true)
    }
    
    private func animateDetectionView(hidden: Bool) {
        
        UIView.animate(withDuration: 0.5, animations: { 
            
            self.overlayView.alpha = hidden ? 1 : 0
            self.bottomToBottomSpacingConstraint.constant = hidden ? -self.detectionView.bounds.height : 0
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
            
            self.view.isUserInteractionEnabled = !hidden
        })
    }
}

private extension SingingDetectorViewController {

    func setupPlot() {
        
        let plot = AKNodeOutputPlot(detector.mic, frame: audioInputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = .blue
        plotSubview = plot
        audioInputPlot.addSubview(plot)
    }
}

