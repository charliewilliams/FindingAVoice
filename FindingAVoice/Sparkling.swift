//
//  Sparkling.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 07/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

protocol Sparkling {
    func sparkle()
}

extension Sparkling where Self: UIView {
    
    func sparkle() {
        
        // particles
        let layer = CAEmitterLayer()
        layer.emitterSize = CGSize(width: 25, height: 25)
        layer.emitterPosition = CGPoint(x: center.x, y: center.y - frame.origin.y)
        layer.renderMode = CAEmitterLayerRenderMode.additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 1
        cell.lifetimeRange = 0.5
        cell.color = UIColor(white: 1.0, alpha: 1.0).cgColor
        cell.contents = #imageLiteral(resourceName: "sparkle").cgImage
        cell.scaleSpeed = 0.3
        cell.spin = 0.5
        cell.velocity = 100
        cell.velocityRange = 200
        cell.emissionRange = .pi * 2
        
        layer.emitterCells = [cell]
        
        self.layer.addSublayer(layer)
        
        delay(0.3) {
            
            layer.birthRate = 0
            
            delay(1.5) {
                
                layer.removeFromSuperlayer()
            }
        }
    }
}
