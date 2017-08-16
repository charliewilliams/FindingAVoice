//
//  MusicPlayerContainerViewController.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerContainerViewController: UIViewController, ScreenReporting {

    fileprivate(set) static var userHasAnsweredAllSongs: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "userHasAnsweredAllSongs")
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "userHasAnsweredAllSongs")
        }
    }
    @IBOutlet weak var yesWellButton: UIButton!
    @IBOutlet weak var yesHaveHeardButton: UIButton!
    @IBOutlet weak var noDontKnowButton: UIButton!
    var songs = [Song]()
    var currentSong: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songs = SongLoader.songs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if volumeIsTooSoft {
            popVolumeAlert()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
        
        // play the first one
        playNextSong()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        setButtonsEnabled(false)
        
        // figure out which button and mark the song as unavailable if they've said no
        guard var currentSong = currentSong,
            let index = [noDontKnowButton, yesHaveHeardButton, yesWellButton].index(of: sender) else {
                assertionFailure()
                return
        }
        
        currentSong.knowledgeLevel = Song.KnowledgeLevel(rawValue: index)
        Analytics.songKnowledgeLevelMarked(currentSong, duration: resetTimer())
        
        playNextSongOrFinish()
    }
    
    @IBAction func debugSkipButtonPressed(_ sender: Any) {
        
        for var song in songs {
            song.knowledgeLevel = Song.KnowledgeLevel.some
        }
        finish()
    }
    
    var lastTime: TimeInterval = NSDate().timeIntervalSince1970
    func resetTimer() -> TimeInterval {
        
        let now = NSDate().timeIntervalSince1970
        let elapsed = now - lastTime
        lastTime = now
        
        return elapsed
    }
}

private extension MusicPlayerContainerViewController {
    
    func playNextSongOrFinish() {
        
        guard songs.count > 0 else {
            finish()
            return
        }
        
        delay(2) {
            self.playNextSong()
        }
    }
    
    func playNextSong() {
        
        
        if let oldSong = currentSong {
            oldSong.audioPlayer?.stop()
        }
        
        playerViewController.songs = songs
        
        currentSong = songs.removeFirst()
        let success = currentSong!.audioPlayer?.play() ?? false
        
        if !success {
            print("Failed to play!")
        }
        
        delay(2) {
            self.setButtonsEnabled(true)
        }
    }
    
    func finish() {
        
        // Mark down that we're done
        MusicPlayerContainerViewController.userHasAnsweredAllSongs = true
        
        // Reset so that the songloader loads songs afresh next time
        SongLoader.reset()
        
        // Move to next UI
        navigationController?.popViewController(animated: true)
    }
    
    func setButtonsEnabled(_ enabled: Bool) {
        
        [yesWellButton, yesHaveHeardButton, noDontKnowButton].forEach { b in
            b?.isEnabled = enabled
        }
    }
}

private extension MusicPlayerContainerViewController {
    
    var volumeIsTooSoft: Bool {
        return AVAudioSession.sharedInstance().outputVolume < 0.1
    }
    
    func popVolumeAlert() {
        
        let alertController = UIAlertController(title: "Can you hear the music?", message: "Please turn up the volume on your device", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}

private extension MusicPlayerContainerViewController {
    
    var playerViewController: MusicPlayerCollectionViewController {
        
        for child in childViewControllers {
            if let child = child as? MusicPlayerCollectionViewController {
                return child
            }
        }
        assert(false)
    }
}
