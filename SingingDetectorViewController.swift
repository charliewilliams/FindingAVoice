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
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var detectionLabel: UILabel!
    
    let detector = SingingDetector.shared
    @IBOutlet var audioInputPlot: EZAudioPlot!
    var plotSubview: AKNodeOutputPlot!
    
    @IBOutlet weak var leftDetectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlot()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.started.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.pitchChanged.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gotNotification(note:)), name: NSNotification.Name(rawValue: SingingState.stopped.rawValue), object: nil)
        
        detectionLabel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        plotSubview.frame = audioInputPlot.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        statusLabel.text = "Status: Running"
    }
    
    func gotNotification(note: Notification) {
        
        let state = SingingState(rawValue: note.name.rawValue)!
        
        switch state {
            
        case .started:
            leftDetectionView.isHidden = false
            fallthrough
            
        case .pitchChanged:
            if let noteName = note.userInfo?["noteName"] as? String {
                noteNameLabel.text = noteName
            }
            
        case .stopped:
            noteNameLabel.text = nil
            leftDetectionView.isHidden = true
        }
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

