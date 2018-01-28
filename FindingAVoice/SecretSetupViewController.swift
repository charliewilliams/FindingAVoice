//
//  SecretSetupViewController.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

class SecretSetupViewController: UIViewController {

    @IBOutlet weak var vocabSizeLabel: UILabel!
    @IBOutlet weak var numPrecedentsLabel: UILabel!
    @IBOutlet weak var numConsequentsLabel: UILabel!
    @IBOutlet weak var stringLengthLabel: UILabel!
    @IBOutlet weak var strideLengthLabel: UILabel!
    @IBOutlet weak var densityLabel: UILabel!
    @IBOutlet weak var numberOfRulesLabel: UILabel!
    
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
    
    @IBAction func densitySliderChanged(_ sender: UISlider) {
        densityLabel.text = String(format: "%.3f", sender.value)
    }
    
    @IBAction func numberOfRulesSliderChanged(_ sender: UISlider) {
        numberOfRulesLabel.text = "\(Int(sender.value))"
    }
    
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        
        let destination = QuestionViewController(forPractice: false)
        
        let preceding = Int(numPrecedentsLabel.text!)!
        let following = Int(numConsequentsLabel.text!)!
        let stride = Int(strideLengthLabel.text!)!
//        let length = Int(stringLengthLabel.text!)!
        let density = Float(densityLabel.text!)!
        let numberOfRules = Int(numberOfRulesLabel.text!)!
        
        assert(stride > 0)
        assert(density > 0 && density < 0.5)
        assert(preceding > 0 && following > 0)

        let ruleSet = RuleSet(count: numberOfRules, stringLength: 10, maxPrecedingCount: preceding, maxFollowingCount: following, density: density, maxStride: stride)
        
        destination.ruleSet = ruleSet
        destination.difficulty = DifficultyProvider.currentDifficulty
        
        navigationController?.pushViewController(destination, animated: true)
    }

}

extension SecretSetupViewController: ScreenReporting {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didViewScreen()
    }
}
