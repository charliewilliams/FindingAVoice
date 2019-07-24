//
//  MusicPlayerCollectionViewController.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class MusicPlayerCollectionViewController: UICollectionViewController {

    var songs: [Song]! {
        didSet {
            collectionView!.reloadData()
        }
    }
    
    var backgroundImages = [#imageLiteral(resourceName: "notes_black")]

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewCell
    
        cell.song = songs[indexPath.item]
        cell.backgroundImageView.image = backgroundImages[indexPath.item % backgroundImages.count]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}
