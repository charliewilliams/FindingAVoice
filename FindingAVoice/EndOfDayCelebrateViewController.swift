//
//  EndOfDayCelebrateViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 23/01/2018.
//  Copyright © 2018 Charlie Williams. All rights reserved.
//

import UIKit

class EndOfDayCelebrateViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dayXofYLabel: UILabel!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var seeYouTomorrowButton: UIButton!

    func randomBackgroundImage() -> UIImage {
        return [#imageLiteral(resourceName: "01"), #imageLiteral(resourceName: "02"), #imageLiteral(resourceName: "03"), #imageLiteral(resourceName: "04"), #imageLiteral(resourceName: "05"), #imageLiteral(resourceName: "06"), #imageLiteral(resourceName: "07")].randomItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentContainerView.layer.cornerRadius = 5
        contentContainerView.layer.masksToBounds = true
        seeYouTomorrowButton.layer.cornerRadius = 5
        seeYouTomorrowButton.layer.masksToBounds = true

        backgroundImageView.image = randomBackgroundImage()

        let currentDay = DailyTimer.shared.currentDayNumber
        let numberOfDays = DailyTimer.shared.numberOfDays
        dayXofYLabel.text = "You've completed day \(currentDay) of \(numberOfDays)"

        if currentDay == numberOfDays {
            seeYouTomorrowButton.setTitle("All done! Bye!", for: .normal)
        }
    }
}
