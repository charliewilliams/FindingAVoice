//
//  SongCollectionViewCell.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class SongCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    var song: Song? {
        didSet {
            if let song = song {
                songTitleLabel.text = song.title
            }
        }
    }
}
