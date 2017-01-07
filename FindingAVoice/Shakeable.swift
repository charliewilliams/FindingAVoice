//
//  Shakeable.swift
//  Protocols
//
//  Created by Charlie Williams on 14/12/2016.
//  Copyright © 2016 Charlie Williams. All rights reserved.
//

import UIKit

protocol Shakeable {
    func shake(amount: CGFloat)
}

extension Shakeable where Self: UIView {
    
    func shake(amount: CGFloat = 8) {
        
        let animation = CABasicAnimation(keyPath: "position")
        
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - amount, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + amount, y: self.center.y))
        
        layer.add(animation, forKey: "shakeAnimation")
    }
}
