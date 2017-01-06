//
//  SetupViewController.swift
//  ControlTask
//
//  Created by Charlie Williams on 06/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var vocabSizeLabel: UILabel!
    @IBOutlet weak var numPrecedentsLabel: UILabel!
    @IBOutlet weak var numConsequentsLabel: UILabel!
    @IBOutlet weak var stringLengthLabel: UILabel!
    @IBOutlet weak var strideLengthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func vocabSizeSliderChanged(_ sender: UISlider) {
        vocabSizeLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func precedentsSliderChanged(_ sender: UISlider) {
        numPrecedentsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func consequentsSliderChanged(_ sender: UISlider) {
        numConsequentsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func stringLengthSliderChanged(_ sender: UISlider) {
        stringLengthLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func strideLengthSliderChanged(_ sender: UISlider) {
        strideLengthLabel.text = "\(Int(sender.value))"
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! QuestionViewController
        let preceding = Int(numPrecedentsLabel.text!)!
        let following = Int(numConsequentsLabel.text!)!
        let stride = Int(strideLengthLabel.text!)!
        let length = Int(stringLengthLabel.text!)!
        
        destination.ruleSet = RuleSet(precedingCount: preceding, followingCount: following, stride: stride)
        destination.length = length
    }
}
