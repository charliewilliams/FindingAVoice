//
//  SingingDetector.swift
//  SingingDetectionDemo
//
//  Created by Charlie Williams on 06/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

enum SingingState: String {
    case started
    case pitchChanged
    case stopped
}

class SingingDetector {
    
    fileprivate let noteFrequencies = [16.35,17.32,18.35,19.45,20.6,21.83,23.12,24.5,25.96,27.5,29.14,30.87]
    fileprivate let noteNames = ["C", "C♯","D","E♭","E","F","F♯","G","A♭","A","B♭","B"]
    fileprivate let minPitchAge = 3
    fileprivate let minTrackingAmplitude = 0.01
    
    var currentPitch: String?
    var pitchAge: Int = 0
    var updateTimer: Timer?
    
    let mic = AKMicrophone()
    var tracker: AKFrequencyTracker!
    lazy var outputPlot: AKNodeOutputPlot! = {
        let plot = AKNodeOutputPlot(self.mic, frame: .zero)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = .blue
        return plot
    }()

    static let shared = SingingDetector()
    
    private init() {

        tracker = AKFrequencyTracker(mic)
        AudioKit.output = AKBooster(tracker, gain: 0)
        start()
    }
    
    func start() {

        AudioKit.start()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.tick()
        }
    }
    
    func stop() {

        updateTimer?.invalidate()
        AudioKit.stop()
    }
}

private extension SingingDetector {
    
    func tick() {
        
        if tracker.amplitude > minTrackingAmplitude {
            
            var frequency = Float(tracker.frequency)
            while (frequency > Float(noteFrequencies[noteFrequencies.count - 1])) {
                frequency = frequency / 2.0
            }
            while (frequency < Float(noteFrequencies[0])) {
                frequency = frequency * 2.0
            }
            
            var minDistance: Float = 10000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if (distance < minDistance){
                    index = i
                    minDistance = distance
                }
            }
            
            let octave = Int(log2f(Float(tracker.frequency) / frequency))
            let newPitch = "\(noteNames[index])\(octave)"
            
            if currentPitch == nil {
                currentPitch = newPitch
            }
            
            if let currentPitch = currentPitch, currentPitch == newPitch {
                
                pitchAge += 1
                
                if pitchAge > minPitchAge {
                    sendNotification(forState: .started, pitch: currentPitch, frequency: frequency)
                }
                
            } else {
                
                singingStopped()
            }
            
        } else {
            
            singingStopped()
        }
    }
    
    func singingStopped() {
        
        if currentPitch != nil {
            sendNotification(forState: .stopped)
        }
        currentPitch = nil
        pitchAge = 0
    }
    
    func sendNotification(forState state: SingingState, pitch: String? = nil, frequency: Float? = nil) {
        
        var userInfo: [String: String]?
        
        if let pitch = pitch, let frequency = frequency {
            
            userInfo = ["noteName": pitch,
                        "freq": "\(frequency)"]
            NotificationCenter.default.post(name: Notification.Name(rawValue: state.rawValue), object: nil, userInfo: userInfo)
        }
    }
}

