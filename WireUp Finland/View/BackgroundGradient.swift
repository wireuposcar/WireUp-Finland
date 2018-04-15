//
//  BackgroundGradient.swift
//  WireUp
//
//  Created by Oscar Löfqvist on 19-10-2017.
//  Copyright © 2017 Oscar Löfqvist. All rights reserved.
//

import UIKit

@IBDesignable
class BGCreateAccount: UIView {
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0, green: 0.6470588235, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.3138166536, green: 0.9945509283, blue: 1, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}



