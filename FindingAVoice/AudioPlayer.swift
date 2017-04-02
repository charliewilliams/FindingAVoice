//
//  AudioPlayer.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import AVFoundation

struct AudioPlayer {
    
    static var currentPlayer: AVAudioPlayer?
    
    static func playAudio(withFilename filename: String) -> AVAudioPlayer? {
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            return nil
        }
        
        currentPlayer?.stop()
        
        currentPlayer = try? AVAudioPlayer(contentsOf: url)
        currentPlayer?.play()
        
        return currentPlayer
    }
}
